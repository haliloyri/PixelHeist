extends RefCounted
## Direct outdoor routes and orthogonal empty-cell routes: choose the shortest
## permitted approach, stop beside the target and return to the departure dock.

static func grid_point(cell: Vector2i, area: Rect2, width: int) -> Vector2:
	return area.position + (Vector2(cell) + Vector2(.5,.5)) * (area.size.x / width)

## `gaps` (2026-09-26): x positions of the passages cut through the bottom frame rail.
## On bottom-entry boards the ants climb through the nearest passage and walk along the
## inside of the rail to their column instead of crossing the rail anywhere.
## Distance below the frame where an ant waits while a passage is being cut.
const GATE_GAP := 3.0

static func plan(puzzle, target: int, area: Rect2, frame: Rect2, origin: Vector2, dock: Vector2, gaps: Array = [], gap_width: float = 0.0) -> Dictionary:
	var w: int = puzzle.width
	var h: int = puzzle.height
	var start := Vector2i(target % w, target / w)
	var queue: Array[Vector2i] = [start]
	var parents := {start: start}
	var distances := {start: 0}
	var head := 0
	var best_cost := INF
	var best := Vector2i(-999,-999)
	var best_entry := Vector2.ZERO
	var best_gap := -1
	var best_crossing := 0.0
	var rim := frame.grow(18)
	var tile := area.size.x / w
	while head < queue.size():
		var cell := queue[head]
		head += 1
		for delta in [Vector2i.LEFT,Vector2i.RIGHT,Vector2i.UP,Vector2i.DOWN]:
			var next: Vector2i = cell + delta
			if puzzle.entry_mode=="bottom" and (next.x<0 or next.x>=w or next.y<0): continue
			if next.x < -1 or next.y < -1 or next.x > w or next.y > h or parents.has(next): continue
			if next.x >= 0 and next.y >= 0 and next.x < w and next.y < h:
				if int(puzzle.board[next.y*w+next.x]) >= 0: continue
			parents[next] = cell
			distances[next] = int(distances[cell])+1
			if next.x == -1 or next.y == -1 or next.x == w or next.y == h:
				var point := grid_point(next,area,w)
				var entry := point
				if next.x == -1: entry.x = rim.position.x
				elif next.x == w: entry.x = rim.end.x
				elif next.y == -1: entry.y = rim.position.y
				else: entry.y = rim.end.y
				var interior := float(distances[next])*tile
				var cost := interior + point.distance_to(entry) + path_length(outside_path(origin,entry,rim))
				var gap_index := -1
				var crossing := 0.0
				if puzzle.entry_mode=="bottom" and next.y==h and not gaps.is_empty():
					cost = INF
					for i in gaps.size():
						# Use the opening's width instead of funnelling every ant through
						# its centre. Keep body clearance at the cut edges.
						var half_width := maxf(0.0,gap_width*.5-6.0)
						var gx := clampf(point.x,float(gaps[i])-half_width,float(gaps[i])+half_width)
						var gate_point := Vector2(gx,frame.end.y+GATE_GAP)
						var candidate := interior + absf(point.x-gx) + absf(gate_point.y-point.y) + origin.distance_to(gate_point)
						if candidate < cost:
							cost = candidate
							gap_index = i
							crossing = gx
				if cost < best_cost:
					best_cost = cost
					best = next
					best_entry = entry
					best_gap = gap_index
					best_crossing = crossing
			else: queue.append(next)
	if best.x == -999: return {}
	var empty_cells: Array[Vector2i] = []
	var current := best
	while current != start:
		empty_cells.append(current)
		current = parents[current]
	var inside: Array[Vector2] = []
	for cell in empty_cells: inside.append(grid_point(cell,area,w))
	var through_gap: bool = puzzle.entry_mode=="bottom" and best.y==h and not gaps.is_empty() and not inside.is_empty()
	var gap := best_gap
	var gate := -1
	var outbound: Array[Vector2]
	var approach: Array[Vector2] = []
	if through_gap:
		var gx := best_crossing
		var inner_y: float = inside[0].y
		outbound = [origin]
		# The ant stops just under the rail (GATE) until its passage is cut open.
		_append_distinct(outbound,Vector2(gx,frame.end.y+GATE_GAP))
		gate = outbound.size()
		_append_distinct(outbound,Vector2(gx,inner_y))
		approach = [dock]
		for point in [Vector2(gx,frame.end.y+GATE_GAP),Vector2(gx,inner_y)]: _append_distinct(approach,point)
	else:
		outbound = outside_path(origin,best_entry,rim)
		approach = outside_path(dock,best_entry,rim)
	for point in inside: _append_distinct(outbound,point)
	var inbound: Array[Vector2] = []
	for i in range(inside.size()-1,-1,-1): _append_distinct(inbound,inside[i])
	for i in range(approach.size()-1,-1,-1): _append_distinct(inbound,approach[i])
	var result := {"outbound":outbound,"inbound":inbound,"empty_cells":empty_cells,
		"entry":best_entry,"interior_cost":float(distances[best])*tile,
		"approach_cost":best_cost,"target":grid_point(start,area,w)}
	if through_gap:
		result["gap"] = gap
		result["gate"] = gate
	return result

static func path_length(path: Array[Vector2]) -> float:
	var length := 0.0
	for i in range(1,path.size()): length += path[i-1].distance_to(path[i])
	return length

static func _append_distinct(path: Array[Vector2], point: Vector2) -> void:
	if path.is_empty() or path[-1].distance_to(point) > .01: path.append(point)

static func perimeter_position(distance: float, rect: Rect2) -> Vector2:
	var d := fposmod(distance,2*(rect.size.x+rect.size.y))
	if d <= rect.size.x: return rect.position + Vector2(d,0)
	d -= rect.size.x
	if d <= rect.size.y: return Vector2(rect.end.x,rect.position.y+d)
	d -= rect.size.y
	if d <= rect.size.x: return rect.end - Vector2(d,0)
	return Vector2(rect.position.x,rect.end.y-(d-rect.size.x))

static func perimeter_distance(point: Vector2, rect: Rect2) -> float:
	if is_equal_approx(point.y,rect.position.y): return point.x-rect.position.x
	if is_equal_approx(point.x,rect.end.x): return rect.size.x+point.y-rect.position.y
	if is_equal_approx(point.y,rect.end.y): return rect.size.x+rect.size.y+rect.end.x-point.x
	return 2*rect.size.x+rect.size.y+rect.end.y-point.y

static func clockwise(a: Vector2,b: Vector2,rect: Rect2) -> Array[Vector2]:
	var length := 2*(rect.size.x+rect.size.y)
	var begin := perimeter_distance(a,rect)
	var distance := fposmod(perimeter_distance(b,rect)-begin,length)
	var corners: Array[float] = []
	for corner in [0.0,rect.size.x,rect.size.x+rect.size.y,2*rect.size.x+rect.size.y]:
		var relative := fposmod(float(corner)-begin,length)
		if relative > .01 and relative < distance-.01: corners.append(relative)
	corners.sort()
	var path: Array[Vector2] = [a]
	for offset in corners: _append_distinct(path,perimeter_position(begin+offset,rect))
	_append_distinct(path,b)
	return path

static func outside_path(origin: Vector2,entry: Vector2,rim: Rect2) -> Array[Vector2]:
	var bottom := Vector2(clampf(origin.x,rim.position.x,rim.end.x),rim.end.y)
	var clockwise_length := fposmod(perimeter_distance(entry,rim)-perimeter_distance(bottom,rim),2*(rim.size.x+rim.size.y))
	var perimeter: Array[Vector2]
	if clockwise_length <= rim.size.x+rim.size.y:
		perimeter = clockwise(bottom,entry,rim)
	else:
		perimeter = clockwise(entry,bottom,rim)
		perimeter.reverse()
	var path: Array[Vector2] = [origin]
	for point in perimeter: _append_distinct(path,point)
	return path
