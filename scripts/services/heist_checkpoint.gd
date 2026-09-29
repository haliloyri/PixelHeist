extends RefCounted
## r13 mid-heist resume. A checkpoint is the logical board plus the in-flight motion that
## explains it; loading never invents progress. Boosters (Zap, Scout Fly, Extra Dock,
## Master Key) change queues and dock counts, so queues are validated by conservation
## rather than by authored order.
const Catalog = preload("res://scripts/services/content_catalog.gd")
const VERSION := 2
var catalog = Catalog.new()

static func integer(value, maximum: int = 1000000000) -> bool:
	return (value is int or value is float) and is_finite(float(value)) and float(value) == floor(float(value)) and value >= 0 and value <= maximum

static func number(value, maximum: float) -> bool:
	return (value is int or value is float) and is_finite(float(value)) and value >= 0 and value <= maximum

func motion(game) -> Dictionary:
	return {"flights": game.flights.duplicate(true), "clock": game.clock_accumulator,
		"spawn": game.spawn_accumulator, "pickups": game.pickup_count,
		"departures": game.departures.duplicate(true), "deployments": game.deployments.duplicate(true),
		"rotors": game.rotor_ages.duplicate(), "decoys": game.decoy_ages.duplicate(),
		"queue": game.queue_remaining.duplicate(), "speed": game.speed, "layout": game.heist_layout.duplicate(true)}

func capture(game) -> Dictionary:
	var resume_modal: String = game.modal_kind
	if resume_modal == "settings": resume_modal = "pause"
	return {"version": VERSION, "art_id": game.current_level().art_id,
		"content_hash": catalog.fingerprint(game.current_level()),
		"modal": resume_modal if resume_modal in ["pause", "out_of_space"] else "",
		"puzzle": game.puzzle.snapshot(), "motion": motion(game),
		"used": int(game.boosters_used), "continues": int(game.continues_used)}

func validate(job: Dictionary, levels: Array) -> String:
	if job.is_empty(): return ""
	if job.get("version") != VERSION or not job.get("art_id") is String: return "checkpoint_version"
	var index: int = catalog.art_index(levels, job.art_id)
	if index < 0: return "checkpoint_art"
	var level: Dictionary = catalog.matching_version(levels[index], str(job.get("content_hash", "")))
	if level.is_empty(): return "content_changed"
	if not ["", "pause", "out_of_space"].has(job.get("modal")): return "checkpoint_modal"
	if not integer(job.get("used"), 1000) or not integer(job.get("continues"), 1000): return "checkpoint_counters"
	for key in ["puzzle", "motion"]:
		if not job.get(key) is Dictionary: return "checkpoint_" + key
	return _validate_pair(job.puzzle, job.motion, level)

func _vector(value) -> bool:
	return value is Vector2 and is_finite(value.x) and is_finite(value.y) and absf(value.x) < 10000 and absf(value.y) < 10000

func _validate_pair(p: Dictionary, m: Dictionary, level: Dictionary) -> String:
	var lanes_count: int = int(level.get("slot_count", level.lanes.size()))
	for key in ["board", "lanes", "active"]:
		if not p.get(key) is Array: return key
	var docks: int = p.active.size()
	if p.board.size() != level.cells.size() or p.lanes.size() != lanes_count: return "dimensions"
	if not integer(p.get("base_docks",lanes_count),7): return "dock_count"
	var base: int = int(p.get("base_docks",lanes_count))
	if base not in [lanes_count,5] or docks < base or docks > base + 2: return "dock_count"
	for key in ["remaining", "moves", "serial", "next_reservation_id"]:
		if not integer(p.get(key)): return key
	if not p.get("reservations") is Dictionary: return "reservations"
	if not ["all", "bottom"].has(p.get("entry_mode", "all")): return "entry_mode"
	var remaining := 0
	var balance := {}
	var colors := {}
	for cell in level.cells:
		if int(cell) >= 0: colors[int(cell)] = true
	for cell in p.board.size():
		var color = p.board[cell]
		if not (color is int or color is float) or (color != -1 and color != level.cells[cell]): return "board_color"
		if int(color) >= 0:
			remaining += 1
			balance[int(color)] = int(balance.get(int(color), 0)) + 1
	if remaining != p.remaining: return "remaining"
	for lane in p.lanes:
		if not lane is Array: return "queue_type"
		for packet in lane:
			if not packet is Dictionary or not integer(packet.get("color"), level.palette.size() - 1) or not integer(packet.get("amount"), 999): return "queue_packet"
			if colors.has(int(packet.color)) and not packet.get("decoy", false):
				balance[int(packet.color)] = int(balance.get(int(packet.color), 0)) - int(packet.amount)
	var orders := {}
	for slot in docks:
		if not p.active[slot] is Dictionary: return "queue_type"
		var cap: Dictionary = p.active[slot]
		if cap.is_empty(): continue
		if not integer(cap.get("color")) or not colors.has(int(cap.color)): return "carrier_color"
		if not integer(cap.get("amount")) or not integer(cap.get("left")) or cap.left < 1 or cap.left > cap.amount: return "carrier_capacity"
		if not integer(cap.get("order")) or cap.order >= p.serial or orders.has(int(cap.order)): return "carrier_order"
		orders[int(cap.order)] = slot
		balance[int(cap.color)] = int(balance.get(int(cap.color), 0)) - int(cap.left)
	var cells := {}
	var per_slot := {}
	for id in p.reservations:
		var r = p.reservations[id]
		if not integer(id) or id >= p.next_reservation_id or not r is Dictionary or r.get("id") != id: return "reservation_id"
		if not integer(r.get("cell"), p.board.size() - 1) or cells.has(int(r.cell)): return "reservation_cell"
		if not integer(r.get("slot"), docks - 1) or not r.get("picked") is bool: return "reservation_slot"
		var cap: Dictionary = p.active[int(r.slot)]
		if cap.is_empty() or r.get("color") != cap.color or r.color != level.cells[int(r.cell)]: return "reservation_color"
		if p.board[int(r.cell)] != (-1 if r.picked else r.color): return "pickup_phase"
		cells[int(r.cell)] = true
		per_slot[int(r.slot)] = int(per_slot.get(int(r.slot), 0)) + 1
		if per_slot[int(r.slot)] > cap.left: return "over_reserved"
		if r.picked: balance[int(r.color)] = int(balance.get(int(r.color), 0)) + 1
	for value in balance.values():
		if value != 0: return "pixel_conservation"
	for key in ["flights", "departures", "queue"]:
		if not m.get(key) is Array: return "motion_" + key
	for key in ["deployments", "rotors", "decoys"]:
		if not m.get(key) is Dictionary: return "motion_" + key
	for key in ["clock", "spawn"]:
		if not number(m.get(key), 1): return "motion_time"
	if not integer(m.get("pickups")) or m.pickups != level.cells.filter(func(c): return c >= 0).size() - remaining: return "pickup_count"
	if not [1, 2, 3].has(m.get("speed")): return "speed"
	if m.queue.size() != lanes_count: return "queue_timers"
	for seconds in m.queue:
		if not number(seconds, maxf(0, float(level.queue_seconds))): return "queue_timer"
	if m.flights.size() != p.reservations.size() or m.flights.size() > 36: return "flight_count"
	if m.has("layout"):
		var layout = m.layout
		if not layout is Dictionary or not layout.get("board") is Rect2 or not layout.get("origins") is Array: return "layout"
		if layout.origins.size() < base or layout.origins.size() > 7 or not _vector(layout.board.position) or not _vector(layout.board.size) or layout.board.size.x <= 0 or layout.board.size.y <= 0: return "layout"
		for origin in layout.origins:
			if not _vector(origin): return "layout"
	var seen := {}
	for drone in m.flights:
		if not drone is Dictionary or not p.reservations.has(drone.get("id")) or seen.has(drone.get("id")): return "flight_id"
		seen[drone.id] = true
		var r: Dictionary = p.reservations[drone.id]
		for key in ["cell", "slot", "color"]:
			if drone.get(key) != r[key]: return "flight_" + key
		if drone.get("phase") != (1 if r.picked else 0): return "flight_phase"
		if drone.get("carrier_order") != p.active[int(r.slot)].order: return "flight_carrier"
		for key in ["position", "origin", "target"]:
			if not _vector(drone.get(key)): return "flight_vector"
		for key in ["path", "return_path"]:
			if not drone.get(key) is Array or drone[key].size() < 2: return "flight_path"
			for point in drone[key]:
				if not _vector(point): return "flight_path_point"
		if not integer(drone.get("segment"), drone.path.size()) or drone.segment < 1: return "flight_segment"
		if not number(drone.get("dwell"), 0.55): return "flight_dwell"
		if not number(drone.get("walk_distance",0.0),1000000): return "flight_gait"
	for order in m.deployments:
		var d = m.deployments[order]
		if not orders.has(order) or not d is Dictionary or d.get("slot") != orders[order]: return "deployment"
	for order in m.rotors:
		if not orders.has(order) or not number(m.rotors[order], 0.35): return "rotor"
	for d in m.departures:
		if not d is Dictionary or not _vector(d.get("position")): return "departure"
	return ""
