@tool
extends Control
const HV2 = preload("res://scripts/ui/game_theme.gd")
@export var warm_wood := false
@export var heist_v2 := false ## Only the redesigned heist screen (S06) opts in; other screens keep legacy rendering.
@export_range(-1,14) var location_index := -1:
	set(value):
		location_index=value
		_load_pattern()
var pattern:Texture2D
## 2026-09-25: the heist screen uses the painted museum hall (sc/assets/background.png).
const HALL_PATH := "res://assets/heist_v4/museum.png"
var hall:Texture2D
var game: Control ## Optional; only used by heist_v2 to skip star twinkle when reduced_motion is on.
var gradient_texture: GradientTexture2D
var star_seeds: Array = []
func _load_pattern()->void:
	pattern=null
	if location_index>=0:
		var locations:Array=JSON.parse_string(FileAccess.get_file_as_string("res://data/locations.json"))
		var path:="res://assets/backgrounds/%s.png" % locations[location_index].pattern
		if ResourceLoader.exists(path):pattern=load(path)
	queue_redraw()

func _location() -> Dictionary:
	if location_index<0:return {}
	var locations:Array=JSON.parse_string(FileAccess.get_file_as_string("res://data/locations.json"))
	return locations[location_index] if location_index<locations.size() else {}

## Decorative only: no game state, audio, saves, or dynamic nodes in the editor.
func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	resized.connect(queue_redraw)
	_load_pattern()
	if heist_v2:
		hall=_load_texture(HALL_PATH)
		var gradient:=Gradient.new()
		gradient.set_color(0,HV2.hv2_color("background","gradient_top","#C9C3F0"))
		gradient.set_color(1,HV2.hv2_color("background","gradient_bottom","#F3D6E8"))
		gradient_texture=GradientTexture2D.new()
		gradient_texture.gradient=gradient
		gradient_texture.width=4
		gradient_texture.height=256
		gradient_texture.fill=GradientTexture2D.FILL_LINEAR
		gradient_texture.fill_from=Vector2(0,0)
		gradient_texture.fill_to=Vector2(0,1)
		var rng:=RandomNumberGenerator.new()
		rng.seed=hash("heist_v2_stars_%d" % location_index)
		var count:=rng.randi_range(6,10)
		for i in count:
			var corner:=i%4
			var base:Vector2=[Vector2(60,70),Vector2(660,70),Vector2(60,1130),Vector2(660,1130)][corner]
			star_seeds.append({
				"position": base+Vector2(rng.randf_range(-46,46),rng.randf_range(-46,46)),
				"size": rng.randf_range(2.2,4.4),
				"phase": rng.randf_range(0,TAU),
				"speed": rng.randf_range(.6,1.3),
			})
		set_process(true)

static func _load_texture(path:String)->Texture2D:
	if ResourceLoader.exists(path):return load(path)
	var image:=Image.load_from_file(ProjectSettings.globalize_path(path))
	return ImageTexture.create_from_image(image) if image!=null and not image.is_empty() else null

func _process(_delta: float) -> void:
	if hall!=null:
		set_process(false)
		return
	if not heist_v2 or star_seeds.is_empty():return
	if is_instance_valid(game) and game.reduced_motion:return
	queue_redraw()

func _draw() -> void:
	if heist_v2:
		_draw_heist_v2()
		return
	if pattern!=null:
		var extent:=size
		var scale_factor:=maxf(extent.x/pattern.get_width(),extent.y/pattern.get_height())
		var draw_size:=Vector2(pattern.get_size())*scale_factor
		draw_texture_rect(pattern,Rect2((extent-draw_size)*.5,draw_size),false)
		draw_rect(Rect2(Vector2.ZERO,extent),Color(1,.98,.94,.48))
		var header:=StyleBoxFlat.new()
		header.bg_color=Color(1,.98,.94,.82)
		header.set_corner_radius_all(16)
		draw_style_box(header,Rect2(100,12,485,53))
		return
	if warm_wood:
		_draw_wood()
		return
	draw_rect(Rect2(Vector2.ZERO, size), Color("0d141e"))
	for x in range(0, 721, 60):
		draw_line(Vector2(x, 0), Vector2(x, size.y), Color("121c28"), 1)
	for y in range(0, int(size.y)+1, 60):
		draw_line(Vector2(0, y), Vector2(720, y), Color("121c28"), 1)
	draw_circle(Vector2(620, 160), 210, Color(.20, .27, .30, .06))
	draw_circle(Vector2(35, 600), 280, Color(.3, .23, .15, .05))

func _draw_wood() -> void:
	draw_rect(Rect2(Vector2.ZERO,size),Color("edc6a2"))
	for x in range(0,720,36):
		var tint:=Color("f3d1ae") if (x/36)%3==0 else Color("eac099")
		draw_rect(Rect2(x,0,34,size.y),tint)
		draw_line(Vector2(x,0),Vector2(x,size.y),Color(1,.92,.78,.28),2)
		for strand in 3:
			var points:=PackedVector2Array()
			for y in range(0,int(size.y)+30,24):
				points.append(Vector2(x+7+strand*9+sin(y*.011+x)*1.3,y))
			draw_polyline(points,Color(.56,.32,.18,.065),1,true)

## "Bit'lerin gece soygunu": lavender-to-pink sky, a faint tone-on-tone level
## pattern, slow corner stars and 1-2 data-driven museum silhouettes per side.
func _draw_heist_v2() -> void:
	var extent:=size
	if hall!=null:
		var cover:=maxf(extent.x/hall.get_width(),extent.y/hall.get_height())
		var hall_size:=Vector2(hall.get_size())*cover
		draw_texture_rect(hall,Rect2((extent-hall_size)*.5,hall_size),false)
		return
	if gradient_texture!=null:
		draw_texture_rect(gradient_texture,Rect2(Vector2.ZERO,extent),false)
	else:
		draw_rect(Rect2(Vector2.ZERO,extent),HV2.hv2_color("background","gradient_top","#C9C3F0"))
	if pattern!=null:
		var scale_factor:=maxf(extent.x/pattern.get_width(),extent.y/pattern.get_height())
		var draw_size:=Vector2(pattern.get_size())*scale_factor
		var opacity:float=HV2.HEIST_V2.get("background",{}).get("pattern_opacity",0.08)
		draw_texture_rect(pattern,Rect2((extent-draw_size)*.5,draw_size),false,Color(1,1,1,opacity))
	_draw_silhouettes(extent)
	var static_twinkle:bool=is_instance_valid(game) and bool(game.reduced_motion)
	var star_color:=Color("fffef8")
	var now:=float(Time.get_ticks_msec())*.001
	for star in star_seeds:
		var twinkle:float=1.0 if static_twinkle else .55+.45*sin(now*star.speed+star.phase)
		var glow:=Color(star_color,.55*twinkle)
		draw_circle(star.position,float(star.size)*1.8,glow)
		draw_circle(star.position,float(star.size)*.55,Color(star_color,.85*twinkle+.15))

func _draw_silhouettes(extent: Vector2) -> void:
	var location:=_location()
	var shapes:Array=location.get("silhouettes",[])
	if shapes.is_empty():return
	var color:=HV2.hv2_color("background","silhouette_color","#A9A5D2")
	color.a=HV2.HEIST_V2.get("background",{}).get("silhouette_opacity_max",0.35)
	var slots:=[Vector2(46,extent.y*.62),Vector2(extent.x-46,extent.y*.62)]
	for i in mini(shapes.size(),slots.size()):
		_draw_silhouette(String(shapes[i]),slots[i],color)

## Generic shape primitives keyed by name; the actual shape choice always
## comes from the per-location data table, never hardcoded to a city here.
func _draw_silhouette(kind: String, at: Vector2, color: Color) -> void:
	match kind:
		"amphora":
			draw_rect(Rect2(at+Vector2(-5,-58),Vector2(10,14)),color)
			var body:=PackedVector2Array([at+Vector2(-4,-46),at+Vector2(4,-46),at+Vector2(20,-6),at+Vector2(14,40),at+Vector2(-14,40),at+Vector2(-20,-6)])
			draw_colored_polygon(body,color)
			draw_line(at+Vector2(-18,-30),at+Vector2(-26,-2),color,5,true)
			draw_line(at+Vector2(18,-30),at+Vector2(26,-2),color,5,true)
		"bust":
			draw_rect(Rect2(at+Vector2(-22,26),Vector2(44,20)),color)
			var shoulders:=PackedVector2Array([at+Vector2(-20,26),at+Vector2(20,26),at+Vector2(26,-4),at+Vector2(-26,-4)])
			draw_colored_polygon(shoulders,color)
			draw_circle(at+Vector2(0,-24),16,color)
		"vase":
			var body:=PackedVector2Array([at+Vector2(-16,-40),at+Vector2(16,-40),at+Vector2(22,30),at+Vector2(-22,30)])
			draw_colored_polygon(body,color)
			draw_rect(Rect2(at+Vector2(-10,-52),Vector2(20,14)),color)
		"column":
			draw_rect(Rect2(at+Vector2(-18,-56),Vector2(36,10)),color)
			for x in range(-14,15,7):draw_line(at+Vector2(x,-46),at+Vector2(x,44),color,5,true)
			draw_rect(Rect2(at+Vector2(-18,44),Vector2(36,10)),color)
		"urn":
			draw_circle(at+Vector2(0,4),22,color)
			draw_rect(Rect2(at+Vector2(-8,-38),Vector2(16,24)),color)
			draw_line(at+Vector2(-20,-14),at+Vector2(-26,10),color,5,true)
			draw_line(at+Vector2(20,-14),at+Vector2(26,10),color,5,true)
