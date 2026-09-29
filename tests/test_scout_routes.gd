extends SceneTree
const Routes = preload("res://scripts/core/drone_routes.gd")
const Puzzle = preload("res://scripts/core/puzzle_state.gd")
var checks := 0
var failures := 0
func check(ok: bool,message: String) -> void:
	checks+=1
	if not ok: failures+=1;printerr("FAIL: ",message)
func _initialize() -> void:
	var p := Puzzle.new()
	p.width=5;p.height=5;p.entry_mode="bottom"
	p.board.resize(25);p.board.fill(-1);p.board[2]=0
	var area := Rect2(100,100,100,100)
	var frame := area.grow(18)
	var gaps := [110.0,190.0]
	for side in 2:
		var origin := Vector2(gaps[side],320)
		var r := Routes.plan(p,2,area,frame,origin,origin,gaps)
		check(r.gap==side,"Equal interior routes choose the passage nearest this drone, not a shared path")
		check(r.gate==2 and r.outbound[0]==origin,"Only one direct segment precedes the gate")
		check(is_equal_approx(Routes.path_length(r.outbound.slice(0,2)),origin.distance_to(r.outbound[1])),"Open-space approach is the Euclidean shortest segment")
		var old_detour := absf(origin.x-r.outbound[1].x)+absf(origin.y-r.outbound[1].y)
		check(origin.distance_to(r.outbound[1])<=old_detour,"Direct route cannot exceed the old orthogonal approach")
		var reverse: Array = r.outbound.duplicate();reverse.reverse()
		check(r.inbound==reverse,"Return takes the same shortest safe route to its own drone")
	# A wall forces the route through the only empty corridor, despite a closer gate.
	p.board.fill(0)
	for y in range(1,5):p.board[y*5]=-1
	var blocked := Routes.plan(p,0,area,frame,Vector2(210,320),Vector2(210,320),gaps)
	check(not blocked.is_empty(),"A reachable target behind an obstacle has a route")
	for cell in blocked.empty_cells:
		if cell.y<5:check(p.board[cell.y*5+cell.x]<0,"Route never crosses occupied cells")
		check(cell.x>=0 and cell.x<5 and cell.y>=0,"No side/top rail entry")
	# The width of a cut is usable: different target columns do not collapse to its centre.
	p.board.fill(0)
	var a := Routes.plan(p,22,area,frame,Vector2(140,320),Vector2(140,320),[150.0],60)
	var b := Routes.plan(p,23,area,frame,Vector2(140,320),Vector2(140,320),[150.0],60)
	check(a.outbound[1].x!=b.outbound[1].x,"Different targets use distinct crossing points within one opening")
	for r in [a,b]:
		check(absf(r.outbound[1].x-150)<=24,"Crossing keeps six units clear of the frame edges")
		check(r.outbound[1].y>frame.end.y,"Pecking waits below the closed rail")
		check(r.outbound[2].y<frame.end.y,"Only the gated segment crosses the rail")
	# Fully sealed target cannot manufacture a shortcut through the painting.
	check(Routes.plan(p,12,area,frame,Vector2(140,320),Vector2(140,320),gaps).is_empty(),"Sealed targets have no route")
	print("SCOUT ROUTE CHECKS: %d | FAILURES: %d"%[checks,failures])
	quit(1 if failures else 0)
