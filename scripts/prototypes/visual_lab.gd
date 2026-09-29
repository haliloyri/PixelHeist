extends Control
## P03 presentation sandbox. It owns an isolated PuzzleState and never loads saves.
const L = preload("res://scripts/services/localization.gd")
const V = preload("res://scripts/prototypes/volume_factory.gd")
const State = preload("res://scripts/core/puzzle_state.gd")
const Routes = preload("res://scripts/core/drone_routes.gd")
const INK = Color("17213f")
const PAPER = Color("fff4df")
const BLUE = Color("4775ff")
const CYAN = Color("3edde6")
const GOLD = Color("ffc857")
const CORAL = Color("ff6b83")
var levels: Array = JSON.parse_string(FileAccess.get_file_as_string("res://data/levels.json"))
## The P03 study scripts one exact flight; freeze its board so re-authored
## production queues (P08-I05) cannot change the prototype's timing.
var lab_level: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://scenes/prototypes/lab_level.json"))
func _init() -> void: levels[11] = lab_level
var tokens: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/design_tokens.json"))
var view := "home"
var use_3d := false
var reduced := false
var low_quality := false
var automatic := true
var clock := 0.0
var state = State.new()
var event: Dictionary = {}
var route: Dictionary = {}
var scout_position := Vector3.ZERO
var cells: Dictionary = {}
var carriers: Array[Node3D] = []
var scout: Node3D
var payload: Node3D
var hero: Node3D
var partner: Node3D
var confetti: Array[Node3D] = []
var lift_doors: Array[Node3D] = []
var museum_action: Button
var progress_label: Label
var world: Node3D
var camera: Camera3D
var viewport: SubViewport
var ui: Control
var surface: SubViewportContainer
var modal_card: Control
var camera_target := Vector3(0, 2.3, 6.8)
var camera_look := Vector3(0, 2, -2.3)
var camera_from := Vector3.ZERO
var camera_to := Vector3.ZERO
var travel_started := -1.0
var room_position := 0.0
var inspecting := false
var flight_done := false
var board_area := Rect2(-4.5, -3.5, 9, 9.0 * 22 / 28)

func _ready() -> void:
	L.select("en")
	reset_flight()
	show_view("home")

func reset_flight() -> void:
	state.setup(levels[11])
	state.deploy(0)
	event = state.reserve(1)
	var dock := Vector2(-4.3, 5)
	route = Routes.plan(state, int(event.cell), board_area, board_area.grow(.16), dock, dock)
	flight_done = false

func show_view(next: String) -> void:
	view = next
	clock = 0
	travel_started = -1
	for child in get_children():
		remove_child(child)
		child.queue_free()
	cells.clear()
	carriers.clear()
	scout = null
	payload = null
	hero = null
	partner = null
	confetti.clear()
	lift_doors.clear()
	modal_card = null
	progress_label = null
	ui = Control.new()
	ui.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	ui.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var background := ColorRect.new()
	background.color = PAPER if view == "home" else INK
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	background.show_behind_parent = true
	add_child(background)
	if view != "heist" or use_3d: build_world()
	add_child(ui)
	build_ui()
	update_pose(0)
	queue_redraw()

func build_world() -> void:
	surface = SubViewportContainer.new()
	add_child(surface)
	surface.position = Vector2(0, 230) if view == "heist" else Vector2.ZERO
	surface.size = Vector2(720, 745) if view == "heist" else Vector2(720, 1200)
	if view in ["home","success"]:
		surface.position = Vector2(0,365)
		surface.size = Vector2(720,560)
	surface.stretch = true
	surface.mouse_filter = Control.MOUSE_FILTER_IGNORE
	viewport = SubViewport.new()
	surface.add_child(viewport)
	viewport.own_world_3d = true
	viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	viewport.msaa_3d = Viewport.MSAA_DISABLED if low_quality else Viewport.MSAA_2X
	world = Node3D.new()
	viewport.add_child(world)
	var environment := WorldEnvironment.new()
	world.add_child(environment)
	environment.environment = Environment.new()
	environment.environment.background_mode = Environment.BG_COLOR
	environment.environment.background_color = PAPER if view == "home" else INK
	environment.environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	environment.environment.ambient_light_color = Color("aebfff")
	environment.environment.ambient_light_energy = .40
	var light := DirectionalLight3D.new()
	world.add_child(light)
	light.rotation_degrees = Vector3(-55, -28, 0)
	light.light_color = Color("fff0d7")
	light.light_energy = .78
	light.shadow_enabled = not low_quality
	var fill := DirectionalLight3D.new()
	world.add_child(fill)
	fill.rotation_degrees = Vector3(-35, 130, 0)
	fill.light_color = Color("aec6ff")
	fill.light_energy = .22
	camera = Camera3D.new()
	world.add_child(camera)
	camera.current = true
	if view == "museum":
		lift_doors = V.room(world, levels, low_quality)
		camera.fov = 67
		camera_target = Vector3(room_position, 2.25, 6.8)
		camera_look = Vector3(room_position, 2.0, -2.3)
		camera.position = camera_target
		camera.look_at(camera_look)
	elif view == "heist":
		camera.projection = Camera3D.PROJECTION_ORTHOGONAL
		camera.size = 13.5
		camera.position = Vector3(0, 18, 12)
		camera.look_at(Vector3(0, 0, .7))
		V.box(world, Vector3(0, -.18, .25), Vector3(11.7, .32, 12.5), Color("29385b"), .3)
		V.box(world, Vector3(0, .02, .04), Vector3(9.65, .15, 7.75), GOLD)
		V.box(world, Vector3(0, .12, .04), Vector3(9.3, .12, 7.4), INK)
		var step_size: float = board_area.size.x / state.width
		for index in state.board.size():
			if int(state.board[index]) < 0: continue
			var p := Routes.grid_point(Vector2i(index % state.width, index / state.width), board_area, state.width)
			cells[index] = V.box(world, Vector3(p.x, .29, p.y), Vector3(step_size*.94, .22, step_size*.94), Color(levels[11].palette[int(state.board[index])]), .045)
		for slot in 5:
			var packet: Dictionary = state.active[slot] if not state.active[slot].is_empty() else state.lanes[slot][0]
			var tint := Color(levels[11].palette[int(packet.color)])
			V.cylinder(world, Vector3((slot-2)*2.15, .06, 5), .85, .15, Color("3b4c74"))
			var carrier := V.drone(world, Vector3((slot-2)*2.15, .42, 5), tint, int(packet.get("left", packet.amount)), slot == 0)
			carrier.scale = Vector3.ONE * .85
			carriers.append(carrier)
		scout = V.drone(world, Vector3.ZERO, CYAN)
		scout.scale = Vector3.ONE * .30
		payload = V.box(scout, Vector3(0, -.65, 0), Vector3(.80,.65,.80), Color(levels[11].palette[int(event.color)]))
	else:
		camera.projection = Camera3D.PROJECTION_ORTHOGONAL
		camera.size = 8.6
		camera.position = Vector3(8, 10, 14)
		camera.look_at(Vector3(0, 1.5, 0))
		V.box(world, Vector3(0,-.25,0), Vector3(8,.6,6), BLUE, .2)
		V.box(world, Vector3(0,.12,-1.3), Vector3(5,.3,3), Color("2c3767"), .15)
		V.box(world, Vector3(0,1.8,-1.8), Vector3(4.8,3.5,.5), Color("2c3767"), .15)
		for x in [-2.05, 2.05]: V.box(world, Vector3(x,1.7,-1.42), Vector3(.24,3.6,.22), GOLD)
		V.framed_art(world, Vector3(0, 1.85, -1.45), levels[2], 2.1, 2.6)
		V.box(world, Vector3(0,3.65,-1.7), Vector3(5.2,.36,.8), CORAL)
		for i in 3: V.box(world, Vector3(0,.08-i*.09,1.25+i*.4), Vector3(4.8+i*.6,.15,.6), Color("365bcb"))
		hero = V.drone(world, Vector3(1.25, 2.15, 1.9), CYAN)
		hero.rotation_degrees.y = -15
		V.box(hero, Vector3(0, -.70, 0), Vector3(.55,.55,.55), GOLD)
		if view == "success":
			partner = V.drone(world,Vector3(-2,2.4,1.7),CORAL)
			partner.rotation_degrees.y = 20
			for i in 16:
				var bit := V.box(world,Vector3(sin(i*2.4)*3.4,1+fposmod(i*.71,3.1),cos(i*1.9)*1.8),Vector3(.12,.18,.10),[CYAN,CORAL,GOLD][i%3])
				bit.set_meta("origin",bit.position)
				confetti.append(bit)
		for i in 7:
			var block := V.box(world, Vector3(-2.2+(i%3)*.52, .50+(i/3)*.48, .75), Vector3(.43,.43,.43), [CORAL,GOLD,CYAN][i%3])
			block.rotation_degrees.y = i*12

func label(key: String, rect: Rect2, font_size: int = 23, color: Color = PAPER, parent: Node = null) -> Label:
	var node := Label.new()
	(parent if parent != null else ui).add_child(node)
	node.position = rect.position
	node.size = rect.size
	node.set_meta("text_bounds", rect.size)
	node.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	node.text = L.text(key) if L._source().has(key) else key
	node.add_theme_color_override("font_color", color)
	node.add_theme_font_size_override("font_size", font_size)
	L.fit(node, font_size, 15)
	node.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return node

func style(color: Color, pressed: bool = false) -> StyleBoxFlat:
	var s := StyleBoxFlat.new()
	s.bg_color = color
	s.set_corner_radius_all(int(tokens.radii.button))
	s.border_color = color.darkened(.28)
	s.border_width_bottom = 2 if pressed else 7
	s.shadow_color = Color(0.015,.025,.08,.27)
	s.shadow_size = 5
	s.shadow_offset = Vector2(0, 3)
	return s

func button(key: String, rect: Rect2, action: Callable, color: Color = GOLD, parent: Node = null) -> Button:
	var node := Button.new()
	(parent if parent != null else ui).add_child(node)
	node.position = rect.position
	node.size = rect.size
	node.set_meta("text_bounds",rect.size)
	node.text = L.text(key) if L._source().has(key) else key
	node.clip_text = true
	node.add_theme_color_override("font_color", INK)
	node.add_theme_color_override("font_hover_color", INK)
	node.add_theme_color_override("font_pressed_color", INK)
	node.add_theme_stylebox_override("normal", style(color))
	node.add_theme_stylebox_override("hover", style(color.lightened(.12)))
	node.add_theme_stylebox_override("pressed", style(color.darkened(.08), true))
	node.add_theme_stylebox_override("disabled", style(Color("758099")))
	var focus := style(Color.TRANSPARENT)
	focus.border_color = PAPER
	focus.set_border_width_all(3)
	node.add_theme_stylebox_override("focus",focus)
	L.fit(node, 25, 17)
	node.pressed.connect(action)
	return node

func build_ui() -> void:
	match view:
		"home":
			label("lab.eyebrow",Rect2(44,46,500,30),18,INK)
			button("☰",Rect2(609,38,67,61),func():show_view("modal"),CYAN)
			var shadow := label("PIXEL\nHEIST",Rect2(47,110,625,235),108,BLUE)
			shadow.add_theme_constant_override("line_spacing",-25)
			var title := label("PIXEL\nHEIST",Rect2(40,100,625,235),108,INK)
			title.add_theme_constant_override("line_spacing",-25)
			label("lab.tagline",Rect2(44,329,450,65),27,INK)
			label("lab.hero",Rect2(44,907,610,38),20,INK)
			button("ui.start",Rect2(44,970,632,85),func():show_view("heist"))
			button("lab.collection",Rect2(44,1075,632,72),func():show_view("museum"),CYAN)
		"heist":
			label("ui.chapter_art",Rect2(40,40,530,35),18,CYAN).text = L.text("ui.chapter_art",{"level":"3","art":"2"})
			button("Ⅱ",Rect2(609,34,67,61),func():show_view("modal"),PAPER)
			label(levels[11].title,Rect2(40,99,550,57),38)
			label("queue.deploy",Rect2(40,164,620,45),20,Color("a5b4d9"))
			progress_label = label(L.text("ui.progress",{"done":L.number(state.total-state.remaining),"total":L.number(state.total)}),Rect2(40,982,630,38),20,CYAN)
			button("ui.undo",Rect2(40,1050,196,80),func():reset_flight();clock=0, PAPER)
			button("ui.museum",Rect2(258,1050,418,80),func():show_view("museum"),GOLD)
		"museum":
			label("gallery.name",Rect2(40,40,590,45),31)
			label("lab.collection",Rect2(40,100,500,35),20,CYAN)
			button("×",Rect2(609,34,67,61),func():show_view("home"),PAPER)
			button("‹",Rect2(40,945,76,76),func():move_camera(clampf(room_position-3.05,-8.9,8.9)),PAPER)
			button("›",Rect2(604,945,76,76),func():move_camera(clampf(room_position+3.05,-8.9,8.9)),PAPER)
			label("lab.five",Rect2(147,960,435,44),21).horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			museum_action = button("ui.inspect",Rect2(40,1050,640,82),approach,GOLD)
		"modal":
			var shade := ColorRect.new()
			ui.add_child(shade)
			shade.color = Color(.03,.04,.10,.68)
			shade.size = Vector2(720,1200)
			modal_card = Control.new()
			ui.add_child(modal_card)
			modal_card.position = Vector2(40,225)
			modal_card.size = Vector2(640,755)
			modal_card.pivot_offset = Vector2(320,377)
			var panel := Panel.new()
			modal_card.add_child(panel)
			panel.size = modal_card.size
			var panel_style := style(PAPER)
			panel_style.set_corner_radius_all(int(tokens.radii.modal))
			panel_style.border_color = BLUE
			panel_style.set_border_width_all(5)
			panel_style.border_width_bottom = 13
			panel.add_theme_stylebox_override("panel", panel_style)
			label("lab.dossier",Rect2(34,34,475,29),18,BLUE,modal_card)
			button("×",Rect2(542,26,63,60),func():show_view("home"),CYAN,modal_card)
			label("speaker.rocco",Rect2(34,95,560,54),34,INK,modal_card)
			label("art.girl_with_a_pearl_earring.intro",Rect2(34,176,562,207),29,INK,modal_card)
			label("art.girl_with_a_pearl_earring.title",Rect2(34,420,550,83),30,BLUE,modal_card)
			button("ui.start",Rect2(34,562,572,80),func():show_view("heist"),GOLD,modal_card)
			button("lab.return",Rect2(34,658,572,58),func():show_view("home"),CYAN,modal_card)
		"success":
			label("lab.eyebrow",Rect2(40,51,640,30),19,CYAN).horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			label("success.title",Rect2(40,116,640,100),60,GOLD).horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			label("art.girl_with_a_pearl_earring.title",Rect2(60,262,600,74),30).horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			label("lab.hero",Rect2(40,933,640,43),24).horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			button("success.gallery",Rect2(40,1025,640,85),func():show_view("museum"),GOLD)

func move_camera(x: float) -> void:
	room_position = x
	inspecting = false
	museum_action.text = L.text("gallery.enter_lift" if absf(x)>8 else "ui.inspect")
	camera_from = camera.position
	camera_to = Vector3(x,2.25,6.8)
	travel_started = clock
	if reduced:
		camera.position = camera_to
		update_pose(clock)

func approach() -> void:
	camera_from = camera.position
	camera_to = Vector3(room_position,2.25,6.8 if inspecting else (2.2 if absf(room_position)>8 else 1.0))
	inspecting = not inspecting
	travel_started = clock
	if reduced:
		camera.position = camera_to
		update_pose(clock)

func sample_path(path: Array, progress: float) -> Vector2:
	var total := 0.0
	for i in range(1,path.size()): total += path[i-1].distance_to(path[i])
	var distance := clampf(progress,0,1)*total
	for i in range(1,path.size()):
		var length: float = path[i-1].distance_to(path[i])
		if distance <= length: return path[i-1].lerp(path[i], distance / maxf(length,.001))
		distance -= length
	return path[-1]

func update_pose(time: float) -> void:
	clock = time
	if view == "heist":
		var point: Vector2
		if time < 2.5:
			point = sample_path(route.outbound,time/2.5)
		elif time < 3.1:
			point = route.outbound[-1]
		else:
			point = sample_path(route.inbound,(time-3.1)/2.5)
		if time >= 2.8 and state.reservations.has(int(event.id)) and not state.reservations[int(event.id)].picked: state.pickup(int(event.id))
		if time >= 5.6 and not flight_done:
			state.deliver(int(event.id))
			flight_done = true
		scout_position = Vector3(point.x,.9,point.y)
		if is_instance_valid(scout):
			scout.position = scout_position
			scout.visible = not flight_done
			payload.visible = time >= 2.8 and not flight_done
			payload.position = scout.to_local(Vector3(route.target.x,.42,route.target.y)).lerp(Vector3(0,-.65,0),smoothstep(2.8,3.1,time))
			for slot in carriers.size():
				if not state.active[slot].is_empty(): carriers[slot].get_node("Capacity").text = L.number(state.active[slot].left)
			if cells.has(int(event.cell)): cells[int(event.cell)].visible = time < 2.8
		if is_instance_valid(progress_label): progress_label.text = L.text("ui.progress",{"done":L.number(state.total-state.remaining),"total":L.number(state.total)})
		queue_redraw()
	if is_instance_valid(hero): hero.position.y = 2.15 + (0 if reduced else sin(time*2)*float(tokens.motion.hover_amplitude))
	if is_instance_valid(partner):
		partner.position.x = -2 + (0 if reduced else sin(time*1.1)*.4)
		partner.position.y = 2.4 + (0 if reduced else sin(time*2+.5)*.1)
	for i in confetti.size():
		var bit := confetti[i]
		bit.position = bit.get_meta("origin") + Vector3(0,0 if reduced else sin(time*1.6+i)*.25,0)
		bit.rotation = Vector3(.2,.3,.4) if reduced else Vector3(time*.6+i,time*.5,time*.4)
	if view == "museum":
		for door in lift_doors:
			var center: float = door.get_meta("center")
			var opening := clampf((4-camera.position.z)/1.6,0,1) if absf(camera.position.x-center)<1 else 0.0
			door.position.x = center + int(door.get_meta("side"))*(.43+.8*opening)
		if travel_started >= 0:
			var progress := 1.0 if reduced else smoothstep(0,1,clampf((time-travel_started)/float(tokens.motion.travel_seconds),0,1))
			camera.position = camera_from.lerp(camera_to,progress)
		camera.look_at(Vector3(camera.position.x, 2.0, -2.3))
	if is_instance_valid(modal_card):
		var progress := 1.0 if reduced else smoothstep(0,1,clampf(time/float(tokens.motion.modal_seconds),0,1))
		modal_card.scale = Vector2.ONE * lerpf(.94,1,progress)
		modal_card.modulate.a = progress

func _process(delta: float) -> void:
	if automatic: update_pose(clock+delta)

func _unhandled_key_input(input: InputEvent) -> void:
	if not input is InputEventKey or not input.pressed or input.echo: return
	var views: Dictionary = {KEY_F1:"home",KEY_F2:"heist",KEY_F3:"museum",KEY_F4:"modal",KEY_F5:"success"}
	if views.has(input.keycode): show_view(views[input.keycode])
	if input.keycode == KEY_TAB: use_3d = not use_3d; show_view(view)
	if input.keycode == KEY_R: reduced = not reduced; show_view(view)
	if input.keycode == KEY_Q: low_quality = not low_quality; show_view(view)
	if input.keycode == KEY_ESCAPE: show_view("home")

func project(point: Vector3) -> Vector2:
	return Vector2(360+point.x*57, 490+point.z*44-point.y*20)

func tile(point: Vector2, side: float, color: Color) -> void:
	var depth := Vector2(3,5)
	var dimensions := Vector2(side,side*.72)
	var r := Rect2(point-dimensions*.5,dimensions)
	draw_rect(Rect2(r.position+Vector2(2,7),r.size),Color(0,0,0,.28))
	draw_colored_polygon(PackedVector2Array([r.position,r.end-Vector2(0,r.size.y),r.end-Vector2(0,r.size.y)+depth,r.end+depth,r.position+Vector2(0,r.size.y)+depth,r.position]),color.darkened(.34))
	draw_rect(r,color)
	draw_line(r.position+Vector2(1,1),r.position+Vector2(side-1,1),color.lightened(.23),1)

func drone_2d(center: Vector2, color: Color, amount: int = -1, small: bool = false, open: bool = false) -> void:
	var scale_factor := .40 if small else 1.0
	draw_set_transform(center,0,Vector2.ONE*scale_factor)
	draw_style_box(style(Color(0,0,0,.23)),Rect2(-45,15,90,30))
	for x in [-1,1]:
		for y in [-1,1]:
			var pod := Vector2(x*(48 if open else 35),y*18)
			draw_line(Vector2.ZERO,pod,INK,12)
			draw_circle(pod+Vector2(0,6),15,color.darkened(.5))
			draw_circle(pod,15,color.darkened(.2))
			draw_circle(pod,10,INK)
			draw_line(pod-Vector2(10,2),pod+Vector2(10,2),PAPER,3)
	draw_style_box(style(color.darkened(.32)),Rect2(-37,-17,74,56))
	draw_style_box(style(color),Rect2(-37,-28,74,54))
	draw_arc(Vector2(0,-5),28,3.45,5.75,16,color.lightened(.35),3,true)
	draw_style_box(style(INK),Rect2(-18,16,36,15))
	for x in [-1,1]: draw_circle(Vector2(x*9,22),3,CYAN)
	if amount >= 0:
		var text := str(amount)
		var font := ThemeDB.fallback_font
		draw_string(font,Vector2(-font.get_string_size(text,HORIZONTAL_ALIGNMENT_LEFT,-1,30).x*.5,12),text,HORIZONTAL_ALIGNMENT_LEFT,-1,30,INK)
	draw_set_transform(Vector2.ZERO)

func _draw() -> void:
	if view != "heist" or use_3d: return
	# This draw pass sits above the background but below UI (background uses show_behind_parent).
	draw_style_box(style(Color("29385b")),Rect2(40,220,640,685))
	draw_style_box(style(GOLD),Rect2(88,304,544,385))
	var tile_size: float = 9.0/state.width*57
	for index in state.board.size():
		if int(state.board[index]) < 0: continue
		var p := Routes.grid_point(Vector2i(index%state.width,index/state.width),board_area,state.width)
		tile(project(Vector3(p.x,.29,p.y)),tile_size*.93,Color(levels[11].palette[int(state.board[index])]))
	for slot in 5:
		var packet: Dictionary = state.active[slot] if not state.active[slot].is_empty() else state.lanes[slot][0]
		var tint := Color(levels[11].palette[int(packet.color)])
		var center := project(Vector3((slot-2)*2.15,.42,5))
		draw_circle(center+Vector2(0,12),55,Color("3b4c74"))
		drone_2d(center,tint,int(packet.get("left",packet.amount)),false,slot==0)
	if not flight_done:
		var pos := project(scout_position)
		if clock >= 2.8: tile(project(Vector3(route.target.x,.42,route.target.y)).lerp(pos+Vector2(0,17),smoothstep(2.8,3.1,clock)),17,Color(levels[11].palette[int(event.color)]))
		drone_2d(pos,CYAN,-1,true,true)
