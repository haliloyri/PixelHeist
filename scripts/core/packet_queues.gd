extends RefCounted
## Repack only unlaunched capacity. An isolated simulation proves the replacement can finish.
const Puzzle = preload("res://scripts/core/puzzle_state.gd")
const SIZES := [20,24,30,32,37,40,45]
static func migrate(puzzle, level: Dictionary) -> bool:
	if puzzle.queue_version >= 2: return false
	# A queue upgrade must never reinterpret an old board as a newly sampled painting.
	if puzzle.board.size()!=level.cells.size(): return false
	for i in puzzle.board.size():
		if puzzle.board[i]>=0 and puzzle.board[i]!=level.cells[i]: return false
	var sim = Puzzle.new()
	sim.setup(level)
	sim.restore(puzzle.snapshot())
	var budget := {}
	var decoys: Array = []
	for lane in puzzle.lanes:
		for packet in lane:
			if packet.get("decoy",false): decoys.append(packet.duplicate())
			else: budget[int(packet.color)] = int(budget.get(int(packet.color),0))+int(packet.amount)
	# Settle carried pixels only in the planner; the real ants and reservations are untouched.
	for id in sim.reservations.keys():
		if sim.reservations[id].picked: sim.deliver(int(id))
		else: sim.cancel_reservation(int(id))
	var lanes: Array = []
	for column in puzzle.slot_count: lanes.append([])
	var serial := 0
	while sim.remaining > 0:
		sim.settle()
		if sim.remaining == 0: break
		if sim.free_slot() < 0: return false
		var counts := {}
		for cell in sim.accessible_cells():
			var color := int(sim.board[cell])
			if int(budget.get(color,0)) > 0: counts[color] = int(counts.get(color,0))+1
		if counts.is_empty(): return false
		var chosen := -1
		var score := -1
		for color in counts:
			var occupied: bool = sim.active.any(func(c): return not c.is_empty() and int(c.color)==color)
			var priority: int = int(counts[color])+(0 if occupied else 10000)
			if priority > score: chosen = color; score = priority
		var left := int(budget[chosen])
		var amount := left
		if left > 45:
			amount = int(SIZES[serial%SIZES.size()])
			if left-amount < 20: amount = left-20
		budget[chosen] = left-amount
		var column: int = serial%puzzle.slot_count
		var packet := {"color":chosen,"amount":amount}
		if serial > puzzle.slot_count and serial%4==1: packet.mystery = true
		lanes[column].append(packet)
		sim.lanes[column] = [packet.duplicate()]
		if not sim.deploy(column): return false
		serial += 1
	if budget.values().any(func(value): return value != 0): return false
	# Retain legacy decoys, capped to a visible two-digit budget; they consume no art.
	for i in decoys.size():
		var column: int = i%puzzle.slot_count
		decoys[i].amount = mini(20,puzzle.remaining)
		lanes[column].append(decoys[i])
	puzzle.lanes = lanes
	puzzle.queue_version = 2
	return true
