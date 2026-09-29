extends Control
## Live carriers and queue; the separate depth renderer still owns the 3D puzzle tiles.
const HeistStyle = preload("res://scripts/ui/heist_skin.gd")
const Layout = preload("res://scripts/ui/queue_layout.gd")
const BeamFX = preload("res://scripts/ui/row_beam_fx.gd")
const Drone = preload("res://scripts/ui/drone_design.gd")
var game: Control
var phase := 0.0

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	clip_contents = true
	size = Vector2(720,1180)

func _process(delta: float) -> void:
	if is_instance_valid(game) and game.modal_kind.is_empty() and not game.app_suspended:
		if not game.reduced_motion: phase += delta*24
	queue_redraw()

func _draw() -> void:
	if not is_instance_valid(game) or game.screen != "play": return
	var palette: Array = game.current_level().palette
	var count: int = game.puzzle.dock_count()
	for slot in count:
		var at: Vector2 = game.dock_position(slot)
		var width := Layout.cube_size(count).x
		var pad := Rect2(at+Vector2(-width*.58,22),Vector2(width*1.16,31))
		draw_texture_rect(HeistStyle.region(Rect2(7,806,153,94)),pad.grow_individual(0,15,0,2),false)
		var c: Dictionary = game.puzzle.active[slot]
		if c.is_empty(): continue
		var pose: Dictionary = game.carrier_pose(slot)
		var face_count: int = game.carrier_display_count(slot)
		HeistStyle.carrier(self,pose.position,Color(palette[int(c.color)]),str(face_count) if face_count > 0 else "",width,false,phase)
	for column in game.puzzle.slot_count:
		if not game.queue_column_visible(column): continue
		var visual: int = column % 3
		var lane: Array = game.puzzle.lanes[column]
		for depth in mini(4,lane.size()):
			var c: Dictionary = lane[depth]
			var hidden: bool = depth > 0 and c.get("mystery",false)
			var tint := Color("657282") if hidden else Color(palette[int(c.color)])
			var at: Vector2 = Layout.row(visual,3,depth)+game.heist_offset()
			HeistStyle.carrier(self,at,tint,"?" if hidden else str(mini(int(c.amount),game.puzzle.remaining)),Layout.cube_size(count).x,false)
	for d in game.departures:
		var pose := Drone.departure_pose(d,game.DEPARTURE_TIME)
		draw_set_transform(pose.position,-float(d.side)*.2)
		HeistStyle.carrier(self,Vector2.ZERO,Color(palette[int(d.color)]),"",Layout.cube_size(count).x,smoothstep(0,.25,float(d.age)),phase)
		draw_set_transform(Vector2.ZERO)
	_draw_beam_pixels(palette)

func _draw_beam_pixels(palette: Array) -> void:
	for effect in game.beam_effects:
		var start: Vector2 = game.board_art.visual_cell_position(int(effect.cell))
		var target: Vector2 = game.beam_target_position(effect.target)
		var pose := BeamFX.pose(effect,start,target)
		var tint := preload("res://scripts/ui/artwork_pixels.gd").color_at(game.current_level(),int(effect.cell))
		var tile: float = game.board_art.visual_rect().size.x/game.puzzle.width
		var side: float = maxf(1,tile*float(pose.scale))
		var point: Vector2 = pose.position
		var alpha: float = pose.alpha
		if alpha <= .001: continue
		if pose.flash > 0:
			draw_rect(Rect2(start-Vector2.ONE*tile*.6,Vector2.ONE*tile*1.2),Color(HeistStyle.ICE,float(pose.flash)*.85),false,2,true)
		if pose.travel > .02 and not effect.reduced:
			var direction := (target-start).normalized()
			for trail in range(3,0,-1):
				var echo := point-direction*float(trail)*tile*.75
				draw_rect(Rect2(echo-Vector2.ONE*side*.45,Vector2.ONE*side*.9),Color(tint,alpha*.10*(4-trail)))
		var rect := Rect2(point-Vector2.ONE*side*.5,Vector2.ONE*side)
		draw_rect(rect.grow(1),Color(tint.darkened(.5),alpha))
		draw_rect(rect,Color(tint,alpha))
		draw_line(rect.position,rect.position+Vector2(side,0),Color(tint.lightened(.55),alpha),maxf(1,side*.12),true)
		if pose.travel > .5 and not effect.reduced:
			for speck in 3:
				var angle := float(effect.cell)*.7+float(speck)*TAU/3
				var offset := Vector2.from_angle(angle)*tile*float(pose.travel)
				draw_circle(point+offset,maxf(.6,side*.12),Color(tint.lightened(.35),alpha*.65))
