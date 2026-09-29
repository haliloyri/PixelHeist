extends RefCounted
## Three actual mesh faces with a consistent oblique projection, aligned to cell centers.
## Top is the matching color; right/front shades describe depth, not extra game colors.
## The three projected faces exactly tile a full cell: no exposed backing wedges.
const TOP := [Vector2(-.5,-.5),Vector2(.28,-.5),Vector2(.28,.12),Vector2(-.5,.12)]
const BASE := [Vector2(-.5,-.5),Vector2(.5,-.5),Vector2(.5,.5),Vector2(-.5,.5)]

static func draw_pixel(canvas: CanvasItem, center: Vector2, size: float, tint: Color) -> void:
	var p: PackedVector2Array = []
	for point in TOP: p.append(center+point*size)
	var b: PackedVector2Array = []
	for point in BASE: b.append(center+point*size)
	canvas.draw_colored_polygon(PackedVector2Array([p[1],b[1],b[2],p[2]]),tint.darkened(.38))
	canvas.draw_colored_polygon(PackedVector2Array([p[2],b[2],b[3],p[3]]),tint.darkened(.20))
	canvas.draw_colored_polygon(p,tint)
	canvas.draw_polyline(PackedVector2Array([p[3],p[0],p[1]]),tint.lightened(.18),maxf(.5,size*.025),true)

static func mesh(size: float, tilt: float) -> ArrayMesh:
	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	var top: Array[Vector3] = []
	var bottom: Array[Vector3] = []
	for i in TOP.size():
		var p: Vector2 = TOP[i]
		var height := size*.35
		top.append(Vector3(p.x*size,height,(p.y*size+height*sin(tilt))/cos(tilt)))
		bottom.append(Vector3(BASE[i].x*size,0,BASE[i].y*size/cos(tilt)))
	_face(st,[top[0],top[1],top[2],top[3]],Color.WHITE)
	_face(st,[top[1],bottom[1],bottom[2],top[2]],Color(.62,.62,.62))
	_face(st,[top[2],bottom[2],bottom[3],top[3]],Color(.80,.80,.80))
	st.generate_normals()
	return st.commit()

static func _face(st: SurfaceTool, points: Array, tint: Color) -> void:
	st.set_color(tint)
	for i in [0,1,2,0,2,3]: st.add_vertex(points[i])
