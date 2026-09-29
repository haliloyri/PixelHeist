extends RefCounted
## Original low-poly enamel forms for P03 comparison, with no gameplay ownership.
const CubeSkin = preload("res://scripts/ui/cube_skin.gd")
static var meshes: Dictionary = {}
static var materials: Dictionary = {}

static func material(color: Color, roughness: float = 0.4, metallic: float = 0.0) -> StandardMaterial3D:
	var key := "%s:%s:%s" % [color.to_html(), roughness, metallic]
	if materials.has(key): return materials[key]
	var m := StandardMaterial3D.new()
	m.albedo_color = color
	m.roughness = roughness
	m.metallic = metallic
	materials[key] = m
	return m

static func beveled_mesh(size: Vector3, bevel: float) -> ArrayMesh:
	var key := str(size) + ":" + str(bevel)
	if meshes.has(key): return meshes[key]
	var half := Vector2(size.x, size.z) * .5
	var b := minf(bevel, minf(minf(size.x, size.z), size.y) * .22)
	var ring := PackedVector2Array([Vector2(-half.x+b,-half.y),Vector2(half.x-b,-half.y),Vector2(half.x,-half.y+b),Vector2(half.x,half.y-b),Vector2(half.x-b,half.y),Vector2(-half.x+b,half.y),Vector2(-half.x,half.y-b),Vector2(-half.x,-half.y+b)])
	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	st.set_smooth_group(-1)
	var rings: Array = []
	for layer in 3:
		var points: Array[Vector3] = []
		for point in ring:
			var p := point
			if layer == 2: p *= Vector2((half.x-b)/half.x,(half.y-b)/half.y)
			points.append(Vector3(p.x, -size.y*.5 if layer==0 else size.y*.5-(b if layer==1 else 0), p.y))
		rings.append(points)
	for i in 8:
		var j := (i+1)%8
		for layer in 2:
			for point in [rings[layer][i], rings[layer][j], rings[layer+1][i], rings[layer][j], rings[layer+1][j], rings[layer+1][i]]: st.add_vertex(point)
		for point in [Vector3(0,size.y*.5,0),rings[2][i],rings[2][j]]: st.add_vertex(point)
		for point in [Vector3(0,-size.y*.5,0),rings[0][j],rings[0][i]]: st.add_vertex(point)
	st.generate_normals()
	var mesh := st.commit()
	meshes[key] = mesh
	return mesh

static func box(parent: Node3D, position: Vector3, size: Vector3, color: Color, bevel: float = 0.08) -> MeshInstance3D:
	var node := MeshInstance3D.new()
	node.mesh = beveled_mesh(size, bevel)
	node.position = position
	node.material_override = material(color)
	parent.add_child(node)
	return node

static func ellipsoid(parent: Node3D, position: Vector3, size: Vector3, color: Color) -> MeshInstance3D:
	var node := MeshInstance3D.new()
	var mesh := SphereMesh.new()
	mesh.radius = .5
	mesh.height = 1
	mesh.radial_segments = 24
	mesh.rings = 12
	node.mesh = mesh
	node.scale = size
	node.position = position
	node.material_override = material(color, .26)
	parent.add_child(node)
	return node

static func cylinder(parent: Node3D, position: Vector3, radius: float, height: float, color: Color) -> MeshInstance3D:
	var node := MeshInstance3D.new()
	var mesh := CylinderMesh.new()
	mesh.top_radius = radius
	mesh.bottom_radius = radius
	mesh.height = height
	mesh.radial_segments = 24
	node.mesh = mesh
	node.position = position
	node.material_override = material(color)
	parent.add_child(node)
	return node

## Hive drone body, heist-v2 toy language (2026-09-23 follow-up -- the previous 4-corner-rotor
## capsule was never actually restyled here even though drone_design.gd's flat 2D paint() was;
## depth_heist.gd's voxel projection is what the game actually shows, and this is its drone).
## Rounded flattened capsule, glossy artwork-tint enamel with a thick dark contour, a front
## capacity "screen", a translucent glass dome, 3 landing legs + contact shadow, and TWO side
## rotor arms (one each side, one rotor per arm) instead of the old 4-corner layout.
static func drone(parent: Node3D, position: Vector3, tint: Color, capacity: int = -1, unfolded: bool = true) -> Node3D:
	var root := Node3D.new()
	parent.add_child(root)
	root.position = position
	var ink := Color("223541")
	ellipsoid(root, Vector3(0, 0, 0), Vector3(1.32, .5, 1.0), ink)
	ellipsoid(root, Vector3(0, .1, 0), Vector3(1.22, .46, .92), tint)
	ellipsoid(root, Vector3(0, .27, -.02), Vector3(.8, .16, .58), tint.lightened(.22))
	box(root, Vector3(0, .16, .46), Vector3(.56, .3, .07), Color("fdfaf1"), .12)
	ellipsoid(root, Vector3(0, .42, -.05), Vector3(.62, .26, .5), Color(0.86, 0.92, 1.0, 0.55))
	for leg in [Vector3(-.5, -.33, .3), Vector3(.5, -.33, .3), Vector3(0, -.33, -.4)]:
		cylinder(root, leg, .05, .18, ink)
	ellipsoid(root, Vector3(0, -.46, 0), Vector3(1.1, .03, .85), Color(0, 0, 0, .16))
	for x in [-1, 1]:
		var spread := .78 if unfolded else .42
		var pod := Vector3(x * spread, .06, 0)
		box(root, pod * .5, Vector3(.5, .1, .14), ink, .05)
		var mount:=Node3D.new();root.add_child(mount);mount.position=pod
		mount.set_meta("rotor_side",Vector2(x,0))
		cylinder(mount, Vector3.ZERO, .22, .1, tint.darkened(.15))
		cylinder(mount, Vector3(0, .07, 0), .17, .02, ink)
		var rotor := box(mount, Vector3(0, .1, 0), Vector3(.42, .02, .06), Color("dceaff"))
		rotor.name="Blade"
		rotor.rotation.y = x * .4
		mount.scale = Vector3.ONE if unfolded else Vector3(.68, 1, .68)
	if capacity >= 0:
		var label := Label3D.new()
		label.name = "Capacity"
		root.add_child(label)
		label.text = str(capacity)
		label.position = Vector3(0, .51, 0)
		label.rotation_degrees.x = -90
		label.font_size = 96
		label.pixel_size = .006
		label.modulate = Color("fff4df")
		label.outline_modulate = ink
		label.outline_size = 14
	return root

## Carrier drone for the heist board (2026-09-25): a camera-facing sprite of one of the
## ten cube skins (scripts/ui/cube_skin.gd) tinted to the artwork colour, capacity on the
## top face, and two rotor arms under it that swing out from the sides when it opens.
static func cube_drone(parent: Node3D, position: Vector3, tint: Color, capacity: int = -1, unfolded: bool = true) -> Node3D:
	var root := Node3D.new()
	parent.add_child(root)
	root.position = position
	var ink := Color("223541")
	var texture := CubeSkin.texture(tint)
	var width := 1.5
	var height := width * float(texture.get_height()) / float(texture.get_width())
	var body := Sprite3D.new()
	body.name = "Body"
	root.add_child(body)
	body.texture = texture
	body.pixel_size = width / float(texture.get_width())
	body.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	body.shaded = false
	body.alpha_cut = SpriteBase3D.ALPHA_CUT_DISCARD
	body.texture_filter = BaseMaterial3D.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS
	body.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	body.position = Vector3(0, .35, 0)
	ellipsoid(root, Vector3(0, -.05, height * .30), Vector3(1.35, .02, .42), Color(0, 0, 0, .18))
	for x in [-1, 1]:
		var mount := Node3D.new()
		root.add_child(mount)
		mount.set_meta("rotor_side", Vector2(x, 0))
		mount.set_meta("rotor_reach", Vector2(.35, .80))
		mount.position = Vector3(x * (1.02 if unfolded else .35), .12, -.08)
		box(mount, Vector3(-x * .25, 0, 0), Vector3(.5, .08, .12), ink, .04)
		cylinder(mount, Vector3.ZERO, .22, .1, tint.darkened(.15))
		cylinder(mount, Vector3(0, .07, 0), .17, .02, ink)
		var rotor := box(mount, Vector3(0, .1, 0), Vector3(.42, .02, .06), Color("dceaff"))
		rotor.name = "Blade"
		rotor.rotation.y = x * .4
	if capacity >= 0:
		var label := Label3D.new()
		label.name = "Capacity"
		root.add_child(label)
		label.text = str(capacity)
		label.position = Vector3(0, .6, 0)
		label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
		label.pixel_size = .006
		label.offset = Vector2(0, height * CubeSkin.TOP_FACE_LIFT / .006)
		label.font_size = 84
		label.modulate = Color("fffef8")
		label.outline_modulate = ink
		label.outline_size = 16
	return root

## Low-poly "Bit" ladybug used for the heist-v2 scout/carrier presentation
## (depth_heist.gd); a fixed red/black palette, independent of artwork tint.
static func bug(parent: Node3D, position: Vector3) -> Node3D:
	var root := Node3D.new()
	parent.add_child(root)
	root.position = position
	var shell := Color("E23B3B")
	var mask := Color("20242B")
	var led := Color("7CF7FF")
	ellipsoid(root, Vector3(0, 0, 0), Vector3(1.0, .62, 1.15), mask)
	for side in [-1, 1]:
		ellipsoid(root, Vector3(side * .26, .22, .05), Vector3(.5, .42, .66), shell)
	box(root, Vector3(0, .05, .55), Vector3(.7, .34, .32), mask, .12)
	for side in [-1, 1]:
		ellipsoid(root, Vector3(side * .24, .14, .68), Vector3(.16, .16, .16), led)
	for side in [-1, 1]:
		cylinder(root, Vector3(side * .2, .4, .62), .02, .3, mask)
	return root

static func pose_rotors(drone: Node3D, openness: float, phase: float) -> void:
	for mount in drone.get_children():
		if not mount.has_meta("rotor_side"): continue
		var side: Vector2=mount.get_meta("rotor_side")
		var reach: Vector2=mount.get_meta("rotor_reach",Vector2(.42,.78))
		mount.position.x=side.x*lerpf(reach.x,reach.y,openness)
		mount.scale=Vector3(lerpf(.68,1,openness),1,lerpf(.68,1,openness))
		mount.get_node("Blade").rotation.y=side.x*.4+phase*openness

static func art_texture(level: Dictionary) -> ImageTexture:
	var image := Image.create(int(level.width), int(level.height), false, Image.FORMAT_RGBA8)
	for index in level.cells.size():
		var color: int = int(level.cells[index])
		image.set_pixel(index % int(level.width), index / int(level.width), Color(level.palette[color]) if color >= 0 else Color("202c48"))
	return ImageTexture.create_from_image(image)

static func framed_art(parent: Node3D, position: Vector3, level: Dictionary, width: float = 1.7, height: float = 2.0) -> Node3D:
	var frame := Node3D.new()
	parent.add_child(frame)
	frame.position = position
	box(frame, Vector3.ZERO, Vector3(width + .20, height + .20, .17), Color("8d5d32"))
	box(frame, Vector3(0, 0, .10), Vector3(width + .12, height + .12, .06), Color("ffc857"))
	box(frame, Vector3(0, 0, .14), Vector3(width, height, .04), Color("fff4df"))
	var art := MeshInstance3D.new()
	var quad := QuadMesh.new()
	quad.size = Vector2(width - .13, height - .13)
	art.mesh = quad
	art.position.z = .17
	var m := material(Color.WHITE).duplicate() as StandardMaterial3D
	m.albedo_texture = art_texture(level)
	m.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
	art.material_override = m
	frame.add_child(art)
	return frame

static func room(parent: Node3D, levels: Array, low_quality: bool = false) -> Array[Node3D]:
	var doors: Array[Node3D] = []
	box(parent, Vector3(0, -.15, 1), Vector3(20, .3, 13), Color("6377a3"))
	box(parent, Vector3(0, 2.5, -3), Vector3(20, 5.2, .3), Color("2c3767"))
	box(parent, Vector3(0, .22, -2.75), Vector3(20, .18, .12), Color("ffc857"))
	box(parent, Vector3(0, 4.8, -2.65), Vector3(20, .18, .3), Color("4775ff"))
	for index in range(-10, 11):
		box(parent, Vector3(index, .013, 2), Vector3(.018, .012, 12), Color("40517a"))
	for index in range(-2, 9):
		box(parent, Vector3(0, .014, index), Vector3(20, .012, .018), Color("40517a"))
	for i in 5:
		var x := (i - 2) * 3.05
		box(parent, Vector3(x, 2.5, -2.78), Vector3(2.64, 4.3, .04), Color("344774"))
		framed_art(parent, Vector3(x, 2.25, -2.55), levels[i + 2], 1.65, 2.05)
		box(parent, Vector3(x, .95, -2.55), Vector3(.8, .18, .08), Color("fff4df"))
		cylinder(parent, Vector3(x, 4.30, -1.8), .12, .18, Color("ffc857"))
		var light := SpotLight3D.new()
		parent.add_child(light)
		light.position = Vector3(x, 4.25, -1.65)
		light.rotation_degrees.x = -35
		light.light_color = Color("ffe4af")
		light.light_energy = 2.1
		light.spot_range = 5
		light.spot_angle = 35
		light.shadow_enabled = not low_quality
	for x in [-8.9, 8.9]:
		box(parent, Vector3(x, 2, -2.30), Vector3(2.1, 4.1, .8), Color("ffc857"))
		box(parent, Vector3(x, 1.9, -1.83), Vector3(1.87, 3.65, .15), Color("17213f"))
		for side in [-1, 1]:
			var door := box(parent, Vector3(x + side * .43, 1.88, -1.7), Vector3(.83, 3.45, .08), Color("4775ff"))
			door.set_meta("center",x)
			door.set_meta("side",side)
			doors.append(door)
		box(parent, Vector3(x, 3.85, -1.70), Vector3(.5, .13, .08), Color("3edde6"))
	return doors
