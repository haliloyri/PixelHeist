extends SubViewportContainer
## Presentation-only projection of the 720x1280 (9:16) logical board and routes.
const V = preload("res://scripts/prototypes/volume_factory.gd")
const Layout = preload("res://scripts/ui/queue_layout.gd")
const Drone = preload("res://scripts/ui/drone_design.gd")
const CubeSkin = preload("res://scripts/ui/cube_skin.gd")
const AntSkin = preload("res://scripts/ui/ant_skin.gd")
const Actors = preload("res://scripts/ui/heist_actors.gd")
const PixelVisualOverlay = preload("res://scripts/ui/pixel_visual_overlay.gd")
var actors: Control
var visual_overlay: Control
var game: Control
var viewport: SubViewport
var world: Node3D
var camera: Camera3D
var tiles: Dictionary = {}
var instances: Dictionary = {}
var crew: Dictionary = {}
var previous: Array = []
var tile_size := 0.1
var rotor_phase := 0.0
var pads: Array = []
var raised := false
const TILT := 0.22
const VIEW_H := 1280.0

func point(position_2d: Vector2, height: float = 0.0) -> Vector3:
	return Vector3((position_2d.x-360)*.01,height,(position_2d.y-VIEW_H*.5)*.01/cos(TILT))

func setup(controller: Control) -> void:
	game=controller
	raised=game.current_level().get("pixel_style", "")=="raised_blocks"
	name="DepthHeist"
	mouse_filter=Control.MOUSE_FILTER_IGNORE
	size=Vector2(720,VIEW_H)
	stretch=true
	viewport=SubViewport.new()
	viewport.size=Vector2i(720,int(VIEW_H))
	viewport.transparent_bg=true
	viewport.own_world_3d=true
	viewport.render_target_update_mode=SubViewport.UPDATE_ALWAYS
	viewport.msaa_3d=Viewport.MSAA_2X
	add_child(viewport)
	world=Node3D.new();viewport.add_child(world)
	camera=Camera3D.new();world.add_child(camera)
	camera.projection=Camera3D.PROJECTION_ORTHOGONAL
	camera.keep_aspect=Camera3D.KEEP_HEIGHT
	camera.size=VIEW_H*.01
	camera.position=Vector3(0,20*cos(TILT),20*sin(TILT))
	camera.look_at(Vector3.ZERO,Vector3(0,0,-1))
	camera.current=true
	var environment:=WorldEnvironment.new();world.add_child(environment)
	environment.environment=Environment.new()
	environment.environment.background_mode=Environment.BG_COLOR
	environment.environment.background_color=Color.TRANSPARENT
	environment.environment.ambient_light_source=Environment.AMBIENT_SOURCE_COLOR
	environment.environment.ambient_light_color=Color.WHITE
	environment.environment.ambient_light_energy=.28
	var light:=DirectionalLight3D.new();world.add_child(light)
	light.rotation_degrees=Vector3(-64,-35,0)
	light.light_energy=.26
	light.shadow_enabled=true
	light.directional_shadow_max_distance=35
	# Visual-only: the painting is shrunk/recentred here for presentation (2026-09-23 feedback);
	# visual_rect() reflects that, while art_rect() (used by main.gd for routing/timing/tie-break)
	# stays at the original size so gameplay never changes.
	var area: Rect2=game.board_art.visual_rect()
	tile_size=area.size.x/game.puzzle.width*.01
	# Build every cube-drone texture for this level now so the first deploy never stutters.
	CubeSkin.warm(game.current_level().palette)
	AntSkin.warm(game.current_level().palette)
	for tint in game.current_level().palette: badge_texture(Color(tint))
	var center: Vector2=game.board_art.position+area.get_center()
	# Dark gallery mat behind the pixels (sits inside the gold frame, main.frame_rect()).
	var backing := V.box(world,point(center,-.085),Vector3(area.size.x*.01+.08,.12,area.size.y*.01/cos(TILT)+.08),Color("1b2133"),.02)
	if raised:
		var backing_material := StandardMaterial3D.new()
		backing_material.albedo_color=Color(game.current_level().board_backing)
		backing_material.shading_mode=BaseMaterial3D.SHADING_MODE_UNSHADED
		backing.material_override=backing_material
	for color in game.current_level().palette.size():
		var ids: Array=[]
		for index in game.current_level().cells.size():
			if game.current_level().cells[index]==color: ids.append(index)
		if ids.is_empty(): continue
		var node:=MultiMeshInstance3D.new();world.add_child(node)
		node.multimesh=MultiMesh.new()
		node.multimesh.transform_format=MultiMesh.TRANSFORM_3D
		var sampled: bool = game.current_level().has("cell_colors")
		node.multimesh.use_colors=sampled
		node.multimesh.mesh=V.beveled_mesh(Vector3(tile_size*.96,tile_size*.38,tile_size*.96/cos(TILT)),tile_size*.09)
		if raised: node.multimesh.mesh=preload("res://scripts/ui/raised_pixel.gd").mesh(tile_size,TILT)
		node.multimesh.instance_count=ids.size()
		node.material_override=V.material(Color(game.current_level().palette[color]),.63)
		if sampled or raised:
			var material := StandardMaterial3D.new()
			material.shading_mode=BaseMaterial3D.SHADING_MODE_UNSHADED
			material.vertex_color_use_as_albedo=true
			if raised:
				material.albedo_color=Color(game.current_level().palette[color])
				material.cull_mode=BaseMaterial3D.CULL_DISABLED
			node.material_override=material
		tiles[color]=node
		for i in ids.size():
			instances[ids[i]]={"mesh":node.multimesh,"index":i}
			if sampled: node.multimesh.set_instance_color(i,preload("res://scripts/ui/artwork_pixels.gd").color_at(game.current_level(),ids[i]))
	if game.current_level().has("pixel_visual_path"):
		visual_overlay = PixelVisualOverlay.new()
		visual_overlay.game = game
		get_parent().add_child(visual_overlay)
		get_parent().move_child(visual_overlay, get_index()+1)
	actors = Actors.new()
	actors.game = game
	get_parent().add_child(actors)
	get_parent().move_child(actors,(visual_overlay.get_index() if is_instance_valid(visual_overlay) else get_index())+1)
	refresh_docks()
	sync()

## Landing plates for every shared dock; rebuilt when Extra Dock / Continue adds one.
func refresh_docks() -> void:
	for pad in pads:
		if pad is Node and is_instance_valid(pad): pad.queue_free()
	pads.clear()
	# Sprite platforms are drawn by HeistActors; retain an inspectable list of dock IDs.
	for slot in game.puzzle.dock_count(): pads.append(slot)
	if is_instance_valid(actors): actors.queue_redraw()

func actor(id: String,tint: Color,capacity: int,open: float) -> Node3D:
	var shape_key := tint.to_html()+":"+str(capacity>=0)
	if crew.has(id) and crew[id].get_meta("shape")!=shape_key:
		world.remove_child(crew[id]);crew[id].queue_free();crew.erase(id)
	if not crew.has(id):
		var node:=V.cube_drone(world,Vector3.ZERO,tint,capacity,open>.05)
		node.set_meta("shape",shape_key)
		crew[id]=node
	var node: Node3D=crew[id]
	node.set_meta("live",true)
	node.set_meta("openness",open)
	V.pose_rotors(node,open,0.0 if game.reduced_motion else rotor_phase)
	var label:=node.get_node_or_null("Capacity")
	if label!=null:
		label.text=str(capacity)
		label.rotation_degrees=Vector3(-90,0,180)
	return node

func bug_actor(id: String) -> Node3D:
	if not crew.has(id):
		var node:=V.bug(world,Vector3.ZERO)
		node.set_meta("shape","bug")
		crew[id]=node
	var node: Node3D=crew[id]
	node.set_meta("live",true)
	return node

func sync() -> void:
	if not is_instance_valid(game) or game.screen!="play" or not is_instance_valid(game.board_art): return
	var changed: bool = previous.size()!=game.puzzle.board.size()
	for index in instances:
		if previous.size()==game.puzzle.board.size() and previous[index]==game.puzzle.board[index]: continue
		changed = true
		var item: Dictionary=instances[index]
		var transform:=Transform3D(Basis.IDENTITY,point(game.board_art.visual_cell_position(index),0.0 if raised else tile_size*.22))
		if game.puzzle.board[index]<0: transform.basis=Basis.from_scale(Vector3.ZERO)
		item.mesh.set_instance_transform(item.index,transform)
	previous=game.puzzle.board.duplicate()
	if changed and is_instance_valid(visual_overlay): visual_overlay.queue_redraw()
	if is_instance_valid(actors): actors.queue_redraw()

## Crew emblem engraved into a departing cube's top face (2026-09-26, Halil: carved into
## the surface, not a coloured sticker). The line art is assets/emblem/crew_emblem_mask.png
## (tools/build_emblem.py: a robot ant carrying one pixel, inside a ring). Each cube colour
## gets its own engraving: dark grooves in the cube's tint with a thin light lower lip.
const EMBLEM_PATH := "res://assets/emblem/crew_emblem_mask.png"
const BADGE_SIZE := 128
const ENGRAVE_LIP := 1
static var _mask: Image
static var _mask_checked := false
static var _engravings: Dictionary = {}

static func _emblem_mask() -> Image:
	if _mask_checked: return _mask
	_mask_checked = true
	var image: Image
	if ResourceLoader.exists(EMBLEM_PATH):
		image = (load(EMBLEM_PATH) as Texture2D).get_image()
	elif FileAccess.file_exists(EMBLEM_PATH):
		image = Image.load_from_file(ProjectSettings.globalize_path(EMBLEM_PATH))
	if image == null or image.is_empty(): return null
	if image.is_compressed(): image.decompress()
	image.convert(Image.FORMAT_RGBA8)
	if image.get_width() != BADGE_SIZE: image.resize(BADGE_SIZE, BADGE_SIZE, Image.INTERPOLATE_LANCZOS)
	_mask = image
	return _mask

static func badge_texture(tint: Color) -> Texture2D:
	var key := tint.to_html(false)
	if _engravings.has(key): return _engravings[key]
	var mask := _emblem_mask()
	if mask == null: return null
	var dark := Color(tint.r * .55, tint.g * .55, tint.b * .55)
	var light := Color(minf(1.0, tint.r * 1.25 + .12), minf(1.0, tint.g * 1.25 + .12), minf(1.0, tint.b * 1.25 + .12))
	var image := Image.create(BADGE_SIZE, BADGE_SIZE, false, Image.FORMAT_RGBA8)
	for y in BADGE_SIZE:
		for x in BADGE_SIZE:
			var groove := mask.get_pixel(x, y).a
			var above := mask.get_pixel(x - ENGRAVE_LIP, y - ENGRAVE_LIP).a if x >= ENGRAVE_LIP and y >= ENGRAVE_LIP else 0.0
			var lip := clampf(above - groove, 0.0, 1.0) * .6
			var alpha := clampf(groove * .85 + lip, 0.0, 1.0)
			if alpha <= 0.0: continue
			var color := (dark * groove + light * lip) / alpha
			color.a = alpha
			image.set_pixel(x, y, color)
	image.generate_mipmaps()
	var texture := ImageTexture.create_from_image(image)
	_engravings[key] = texture
	return texture

func _process(delta: float) -> void:
	if is_instance_valid(game) and not game.app_suspended:
		if game.modal_kind=="": rotor_phase+=delta*24
		sync()
