extends SceneTree

const Puzzle = preload("res://scripts/core/puzzle_state.gd")
var failures := 0
var checks := 0

func check(condition: bool, message: String) -> void:
	checks += 1
	if not condition:
		failures += 1
		printerr("FAIL: ", message)

func _initialize() -> void:
	call_deferred("run")

func run() -> void:
	var started := Time.get_ticks_msec()
	var levels: Array = JSON.parse_string(FileAccess.get_file_as_string("res://data/levels.json"))
	for level in levels:
		var puzzle = Puzzle.new()
		puzzle.setup(level)
		var counts := {}
		for cell in level.cells:
			if int(cell) >= 0: counts[int(cell)] = int(counts.get(int(cell),0)) + 1
		for lane in level.lanes:
			for packet in lane:
				check(int(packet.amount) > 0 and int(packet.amount)<= (7 if int(level.chapter)>=2 else 9), "Small positive capacity")
				if packet.get("decoy",false): continue
				counts[int(packet.color)] = int(counts.get(int(packet.color),0)) - int(packet.amount)
		for count in counts.values(): check(count == 0,"Capacity matches cell count: " + level.title)
		check(puzzle.board.size() == puzzle.width*puzzle.height,"Grid dimensions")
		# Exact authored solutions run through actual flights in test_flow.gd.
		# Instant step() has no flight reservations or timing and is tested separately.
		var authored_lanes:Array=level.lanes.duplicate(true)
		for step_value in level.solution:
			var column:int=int(step_value) if int(step_value)>=0 else -int(step_value)-1
			check(not authored_lanes[column].is_empty(),"Authored column contains its next packet")
			var packet:Dictionary=authored_lanes[column].pop_front()
			check(bool(packet.get("decoy",false))==(int(step_value)<0),"Authored waits correspond exactly to unavailable colours")
		for lane in authored_lanes: check(lane.is_empty(),"Solution consumes each authored queue")
		for column in puzzle.slot_count:
			puzzle.setup(level)
			if not puzzle.can_deploy(column): continue
			var before:Dictionary=puzzle.snapshot()
			check(puzzle.deploy(column),"Deploy valid column")
			puzzle.step()
			check(puzzle.undo() and puzzle.snapshot()==before,"Undo restores a partially or fully collected authored packet")
			check(not puzzle.undo(),"Undo is consumed once")
		print("CONTENT: ",level.title," | ",puzzle.total," cells")
	# A sealed hole must not expose interior cells; opening its shell must do so.
	var ring = Puzzle.new()
	ring.setup({"width":5,"height":5,"cells":[0,0,0,0,0,0,1,1,1,0,0,1,-1,1,0,0,1,1,1,0,0,0,0,0,0],
		"lanes":[[{"color":1,"amount":8}],[{"color":0,"amount":16}],[]]})
	check(ring.accessible_cells().size()==16,"Sealed internal hole does not grant access")
	check(ring.deploy(0),"Inner capsule may wait")
	check(ring.status()=="ready","Waiting with free slots is not a loss")
	check(ring.deploy(1),"Outer capsule deploys")
	ring.settle()
	check(ring.status()=="won","Opening shell unblocks waiting colour")
	var trap = Puzzle.new()
	trap.setup({"width":3,"height":3,"cells":[0,0,0,0,1,0,0,0,0],
		"lanes":[[{"color":1,"amount":1},{"color":0,"amount":8}],[{"color":1,"amount":1},{"color":0,"amount":8}],[{"color":1,"amount":1},{"color":0,"amount":8}]]})
	# Deliberately synthetic capacities isolate full-slot detection from content validity.
	for i in 3: check(trap.deploy(i),"Fill waiting slot")
	check(trap.status()=="blocked","Full idle transfer line is blocked")
	var blocked: Dictionary = trap.snapshot()
	check(not trap.deploy(1),"Cannot deploy into full line")
	check(blocked==trap.snapshot(),"Invalid move is a no-op")
	check(trap.undo() and trap.free_slot()>=0,"Undo recovers from blocked state")
	# Same colour prioritizes activation order, not physical slot position.
	var order = Puzzle.new()
	order.setup({"width":2,"height":1,"cells":[0,0],"lanes":[[],[],[]]})
	order.active[0]={"color":0,"amount":1,"left":1,"order":2}
	order.active[2]={"color":0,"amount":1,"left":1,"order":1}
	check(int(order.step().slot)==2,"Older capsule wins duplicate colour tie")
	check(int(order.step().slot)==0,"Newer capsule follows")
	print("CHECKS: ",checks," | FAILURES: ",failures," | MS: ",Time.get_ticks_msec()-started)
	quit(0 if failures==0 else 1)
