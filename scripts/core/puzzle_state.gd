extends RefCounted
## Deterministic board rules; the controller advances queue and decoy timers.

var queue_version := 0
var slot_count := 3
var base_docks := 3
var entry_mode := "all"
var width: int
var height: int
var board: Array = []
var lanes: Array = []
var active: Array = []
var art_colors: Dictionary = {}
var total := 0
var remaining := 0
var moves := 0
var serial := 0
var undo_state: Dictionary = {}
var frontier: Array = []
var frontier_dirty := true
var reservations: Dictionary = {}
var next_reservation_id := 0
## r13 boosters: docks beyond the lane count (Extra Dock / Continue), the authored
## entry rule restored after a Master Key carrier finishes, and that carrier's order.
const MAX_EXTRA_DOCKS := 2
var authored_entry := "all"
var key_order := -1

func setup(level: Dictionary) -> void:
	queue_version = int(level.get("queue_version",0))
	entry_mode = str(level.get("entry_mode","all"))
	authored_entry = entry_mode
	key_order = -1
	width = int(level.width)
	height = int(level.height)
	board = level.cells.duplicate()
	lanes = level.lanes.duplicate(true)
	slot_count = clampi(int(level.get("slot_count",lanes.size())),3,5)
	while lanes.size()<slot_count: lanes.append([])
	base_docks = slot_count
	active = []
	for slot in slot_count: active.append({})
	total = 0
	art_colors.clear()
	for cell in board:
		if int(cell) >= 0:
			total += 1
			art_colors[int(cell)] = true
	remaining = total
	moves = 0
	serial = 0
	undo_state = {}
	frontier_dirty = true
	reservations = {}
	next_reservation_id = 0

func snapshot() -> Dictionary:
	return {"board": board.duplicate(), "lanes": lanes.duplicate(true),
		"active": active.duplicate(true), "remaining": remaining,
		"moves": moves, "serial": serial,
		"reservations": reservations.duplicate(true), "next_reservation_id": next_reservation_id,
		"entry_mode": entry_mode, "key_order": key_order, "base_docks": base_docks, "queue_version": queue_version}

func restore(saved: Dictionary) -> void:
	queue_version = int(saved.get("queue_version",0))
	base_docks = int(saved.get("base_docks",slot_count))
	board = saved.board.duplicate()
	lanes = saved.lanes.duplicate(true)
	active = saved.active.duplicate(true)
	remaining = int(saved.remaining)
	moves = int(saved.moves)
	serial = int(saved.serial)
	reservations = saved.get("reservations", {}).duplicate(true)
	next_reservation_id = int(saved.get("next_reservation_id", 0))
	entry_mode = str(saved.get("entry_mode", authored_entry))
	key_order = int(saved.get("key_order", -1))
	frontier_dirty = true

func undo() -> bool:
	if undo_state.is_empty():
		return false
	restore(undo_state)
	undo_state = {}
	return true

func dock_count() -> int:
	return active.size()

func extra_docks() -> int:
	return active.size() - base_docks

## Extra Dock booster and Out of Space "Continue": one more shared dock for this heist.
func add_dock() -> bool:
	if extra_docks() >= MAX_EXTRA_DOCKS: return false
	active.append({})
	return true

## Zap booster: an idle docked carrier returns to the back of its own queue.
func can_zap(slot: int) -> bool:
	if slot < 0 or slot >= active.size() or active[slot].is_empty(): return false
	if active[slot].get("decoy", false): return false
	return pending_for(slot) == 0

func zap(slot: int) -> bool:
	if not can_zap(slot): return false
	var capsule: Dictionary = active[slot]
	var column: int = clampi(int(capsule.get("column", slot % slot_count)), 0, slot_count - 1)
	var packet := {"color": int(capsule.color), "amount": int(capsule.left)}
	lanes[column].append(packet)
	if int(capsule.order) == key_order: _end_key()
	active[slot] = {}
	frontier_dirty = true
	return true

## Scout Fly booster: every "?" packet shows its colour and capacity.
func has_mystery() -> bool:
	for lane in lanes:
		for packet in lane:
			if packet.get("mystery", false): return true
	return false

func reveal_mysteries() -> int:
	var count := 0
	for lane in lanes:
		for packet in lane:
			if packet.get("mystery", false):
				packet.erase("mystery")
				count += 1
	return count

## Master Key booster: the next carrier deployed ignores the authored entry side
## until it finishes. Only meaningful on restricted-entry boards.
func can_use_key() -> bool:
	return authored_entry != "all" and key_order < 0

func arm_key() -> bool:
	if not can_use_key(): return false
	key_order = serial
	return true

func _end_key() -> void:
	key_order = -1
	entry_mode = authored_entry
	frontier_dirty = true

## Every occupied dock holds a carrier that cannot work and no dock is free.
func jammed() -> bool:
	return status() == "blocked"

func free_slot() -> int:
	for i in active.size():
		if active[i].is_empty():
			return i
	return -1

func deployment_slot(column: int) -> int:
	if column < 0 or column >= active.size(): return -1
	# Prefer the short vertical transfer, but every empty dock is shared.
	if active[column].is_empty(): return column
	return free_slot()

func can_deploy(column: int) -> bool:
	if column < 0 or column >= slot_count or column >= lanes.size(): return false
	if remaining == 0 or free_slot() < 0 or lanes[column].is_empty(): return false
	var packet: Dictionary = lanes[column][0]
	return art_colors.has(int(packet.color)) and not packet.get("decoy",false)

func deploy(column: int) -> bool:
	if not can_deploy(column): return false
	var slot := deployment_slot(column)
	undo_state = snapshot()
	var capsule: Dictionary = lanes[column].pop_front().duplicate()
	capsule["left"] = int(capsule.amount)
	capsule["column"] = column
	capsule["order"] = serial
	if key_order == serial:
		entry_mode = "all"
		frontier_dirty = true
	serial += 1
	active[slot] = capsule
	moves += 1
	return true

func expire_front(column: int) -> bool:
	if column < 0 or column >= lanes.size() or lanes[column].is_empty(): return false
	var packet: Dictionary = lanes[column].pop_front()
	# Real payloads must never be destroyed: missing one cannot make a level impossible.
	if not packet.get("decoy", false): lanes[column].append(packet)
	return true

func has_decoy() -> bool:
	return active.any(func(c): return c.get("decoy", false))

func accessible_cells() -> Array:
	if not frontier_dirty:
		return frontier
	# Flood the empty space from outside a padded board. Internal holes stay sealed.
	var stride := width + 2
	var seen := PackedByteArray()
	seen.resize(stride * (height + 2))
	var edge := PackedByteArray()
	edge.resize(board.size())
	var queue: Array[int] = []
	if entry_mode=="bottom":
		for x in range(1,width+1):
			var p: int=(height+1)*stride+x
			queue.append(p)
			seen[p]=1
	else:
		queue.append(0)
		seen[0]=1
	var head := 0
	while head < queue.size():
		var p: int = queue[head]
		head += 1
		var x := p % stride
		var y := p / stride
		for direction in [Vector2i.LEFT, Vector2i.RIGHT, Vector2i.UP, Vector2i.DOWN]:
			var nx: int = x + direction.x
			var ny: int = y + direction.y
			if nx < 0 or nx >= stride or ny < 0 or ny >= height + 2:
				continue
			if entry_mode=="bottom" and (nx==0 or nx==width+1 or ny==0): continue
			var np: int = ny * stride + nx
			if seen[np]:
				continue
			seen[np] = 1
			if nx > 0 and nx <= width and ny > 0 and ny <= height:
				var index: int = (ny - 1) * width + nx - 1
				if int(board[index]) >= 0:
					edge[index] = 1
					continue
			queue.append(np)
	frontier = []
	for i in edge.size():
		if edge[i]:
			frontier.append(i)
	frontier_dirty = false
	return frontier

func pending_for(slot: int) -> int:
	var count := 0
	for delivery in reservations.values():
		if int(delivery.slot) == slot: count += 1
	return count

func next_pick(max_per_slot: int = 2147483647, excluded_slots: Array = [], origins: Array = []) -> Vector2i:
	var available := accessible_cells()
	var claimed := {}
	for delivery in reservations.values(): claimed[int(delivery.cell)] = true
	var oldest := 2147483647
	var chosen := Vector2i(-1, -1)
	for slot in active.size():
		if excluded_slots.has(slot) or active[slot].is_empty() or int(active[slot].order) >= oldest:
			continue
		var pending := pending_for(slot)
		if pending >= int(active[slot].left) or pending >= max_per_slot:
			continue
		var closest := INF
		var target := -1
		for index in available:
			if claimed.has(int(index)) or int(board[index]) != int(active[slot].color): continue
			var distance := 0.0
			if origins.size() > slot:
				var point := Vector2(int(index)%width+.5, floori(float(index)/width)+.5)
				distance = point.distance_squared_to(origins[slot])
			if target < 0 or distance < closest:
				target = int(index)
				closest = distance
			if origins.is_empty(): break
		if target >= 0:
			chosen = Vector2i(slot,target)
			oldest = int(active[slot].order)
	return chosen

func can_collect() -> bool:
	return next_pick().x >= 0

func step() -> Dictionary:
	# Instant transaction for solvers/tests; the game uses reserve/pickup/deliver.
	var event := reserve()
	if event.is_empty(): return {}
	pickup(int(event.id))
	return deliver(int(event.id))

func reserve(max_per_slot: int = 2147483647, excluded_slots: Array = [], origins: Array = []) -> Dictionary:
	var pick := next_pick(max_per_slot,excluded_slots,origins)
	if pick.x < 0:
		return {}
	var event := {"id": next_reservation_id, "cell": pick.y, "slot": pick.x,
		"color": int(board[pick.y]), "picked": false}
	reservations[next_reservation_id] = event
	next_reservation_id += 1
	return event.duplicate()

func cancel_reservation(id: int) -> void:
	if reservations.has(id) and not reservations[id].picked: reservations.erase(id)

func pickup(id: int) -> bool:
	if not reservations.has(id) or reservations[id].picked: return false
	var event: Dictionary = reservations[id]
	if int(board[int(event.cell)]) != int(event.color): return false
	board[int(event.cell)] = -1
	event.picked = true
	remaining -= 1
	frontier_dirty = true
	return true

func deliver(id: int) -> Dictionary:
	if not reservations.has(id) or not reservations[id].picked: return {}
	var event: Dictionary = reservations[id].duplicate()
	var capsule: Dictionary = active[int(event.slot)]
	capsule.left = int(capsule.left) - 1
	event["finished"] = int(capsule.left) == 0
	if event.finished:
		if int(capsule.order) == key_order: _end_key()
		active[int(event.slot)] = {}
	reservations.erase(id)
	return event

func settle() -> int:
	var count := 0
	while not step().is_empty():
		count += 1
	return count

func status() -> String:
	if not reservations.is_empty():
		return "collecting"
	if remaining == 0:
		return "won"
	if can_collect():
		return "collecting"
	for column in slot_count:
		if can_deploy(column): return "ready"
		if free_slot() >= 0 and not lanes[column].is_empty(): return "waiting"
	if active.any(func(c): return not c.is_empty()): return "blocked"
	return "invalid"

## New presentation starts with five shared docks; old checkpoints retain their capacity.
func establish_docks(count: int) -> void:
	base_docks = maxi(slot_count,count)
	while active.size() < base_docks: active.append({})

## Lowest occupied row is the beam target. Never steal a pixel reserved by a scout.
func beam_row() -> int:
	for y in range(height-1,-1,-1):
		for x in width:
			if int(board[y*width+x]) >= 0: return y
	return -1

func can_beam() -> bool:
	var row := beam_row()
	if row < 0: return false
	for event in reservations.values():
		if int(event.cell) / width == row: return false
	return true

## Consume the matching outstanding capacities as pixels leave, preserving conservation.
func clear_beam_row() -> Array:
	if not can_beam(): return []
	var row := beam_row()
	var removed: Array = []
	for x in width:
		var cell := row*width+x
		var color := int(board[cell])
		if color < 0: continue
		var consumed := false
		for lane in lanes:
			for packet in lane:
				if int(packet.color) == color and not packet.get("decoy",false):
					packet.amount = int(packet.amount)-1
					if packet.amount == 0: lane.erase(packet)
					consumed = true
					break
			if consumed: break
		if not consumed:
			for slot in active.size():
				var c: Dictionary = active[slot]
				if c.is_empty() or int(c.color) != color or int(c.left) <= pending_for(slot): continue
				c.left = int(c.left)-1
				if c.left == 0:
					if int(c.order) == key_order: _end_key()
					active[slot] = {}
				consumed = true
				break
		if not consumed: continue
		board[cell] = -1
		remaining -= 1
		removed.append(cell)
	frontier_dirty = true
	return removed
