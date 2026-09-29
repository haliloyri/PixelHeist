@tool
extends Button
const Drone=preload("res://scripts/ui/drone_design.gd")
## Folded airframe in the selectable queue.
@export var capsule_color := Color("37b7c8"):
	set(value):
		capsule_color = value
		queue_redraw()
var time_fraction := -1.0
var depth_rendered := false
var arrival := 1.0
func arrive() -> void:
	arrival=0.0
	set_process(true)
func _process(delta: float) -> void:
	arrival=minf(1,arrival+delta*6)
	queue_redraw()
	if arrival>=1: set_process(false)

@export var capacity := 7:
	set(value):
		capacity = value
		text = "" # Capacity is drawn once by the carrier renderer; no native outline overlay.
		queue_redraw()

func _ready() -> void:
	set_process(false)
	focus_mode = Control.FOCUS_NONE
	mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	for state in ["normal","hover","pressed","disabled","focus"]:
		add_theme_stylebox_override(state,StyleBoxEmpty.new())
	for state in ["font_color","font_hover_color","font_pressed_color","font_disabled_color","font_focus_color"]:
		add_theme_color_override(state,Color.TRANSPARENT)
	mouse_entered.connect(queue_redraw)
	mouse_exited.connect(queue_redraw)
	button_down.connect(queue_redraw)
	button_up.connect(queue_redraw)

static func box(canvas: CanvasItem,rect: Rect2,tint: Color,radius: int,border: Color=Color.TRANSPARENT,width: int=0) -> void:
	var style := StyleBoxFlat.new()
	style.bg_color=tint
	style.border_color=border
	style.set_corner_radius_all(radius)
	style.set_border_width_all(width)
	canvas.draw_style_box(style,rect)

static func paint(canvas: CanvasItem,rect: Rect2,tint: Color,amount: int,handle: bool=false,dim: bool=false,pressed: bool=false) -> void:
	var r := rect
	if pressed:r.position.y+=4
	var color := tint
	if dim:color=color.lerp(Color("dcccbf"),.38)
	box(canvas,Rect2(r.position+Vector2(1,8),r.size),Color(0.37,.24,.20,.2),18)
	if handle:
		box(canvas,Rect2(r.position+Vector2(r.size.x*.24,-15),Vector2(r.size.x*.52,27)),color.darkened(.28),10)
		box(canvas,Rect2(r.position+Vector2(r.size.x*.32,-8),Vector2(r.size.x*.36,17)),Color("decdbd"),5)
	box(canvas,r,color.darkened(.30),18,Color(1,1,1,.6) if not dim else color.lightened(.16),3)
	var face:=Rect2(r.position+Vector2(4,3),r.size-Vector2(8,13))
	box(canvas,face,color,15)
	box(canvas,Rect2(face.position+Vector2(6,5),Vector2(face.size.x-12,face.size.y*.28)),color.lightened(.20),11)
	if amount < 0:return
	var font := ThemeDB.fallback_font
	var font_size := int(r.size.y*.57)
	var text := str(amount)
	var extent := font.get_string_size(text,HORIZONTAL_ALIGNMENT_LEFT,-1,font_size)
	var point := r.position+Vector2((r.size.x-extent.x)*.5,(r.size.y-font.get_height(font_size))*.5+font.get_ascent(font_size)-3)
	canvas.draw_string_outline(font,point,text,HORIZONTAL_ALIGNMENT_LEFT,-1,font_size,5,Color("28323a") if not dim else color.darkened(.18))
	canvas.draw_string(font,point,text,HORIZONTAL_ALIGNMENT_LEFT,-1,font_size,Color("fffef8") if not dim else Color(1,1,1,.6))

static func paint_mystery(canvas: CanvasItem, point: Vector2, radius: float) -> void:
	Drone.paint(canvas,point,radius,Color("687b91"),-PI/2,-1,1,0,0)
	var font:=ThemeDB.fallback_font
	var font_size:=int(radius*.69)
	var extent:=font.get_string_size("?",HORIZONTAL_ALIGNMENT_LEFT,-1,font_size)
	var baseline:=point+Vector2(-extent.x*.5,(font.get_ascent(font_size)-font.get_descent(font_size))*.5)
	canvas.draw_string_outline(font,baseline,"?",HORIZONTAL_ALIGNMENT_LEFT,-1,font_size,4,Color("172432"))
	canvas.draw_string(font,baseline,"?",HORIZONTAL_ALIGNMENT_LEFT,-1,font_size,Color("fff6df"))

## Screen rect of the 3D queue cube drawn over this button by depth_heist.gd
## (camera-facing sprite, 1.5 world units wide at .40/.42 scale, lifted .16 + body .35).
func cube_rect() -> Rect2:
	var extent := Vector2(108,108*113.0/148.0)
	return Rect2((size-extent)*.5,extent)

func _draw() -> void:
	if capacity <= 0:return
	var tint := capsule_color
	# 2026-09-26: the light frame hugs the cube itself, not the larger tap target.
	var cube := cube_rect() if depth_rendered else Rect2(Vector2(-3,-3),size+Vector2(6,10))
	if not depth_rendered: box(self,cube.grow(4),Color.TRANSPARENT if depth_rendered else Color(.98,.96,.88,.62),12,Color(.3,.39,.38,.42),2)
	if not depth_rendered: Drone.paint(self,size*.5+Vector2(0,(3 if is_pressed() else 0)+(1.0-smoothstep(0,1,arrival))*17),size.y*.66,tint,-PI/2,capacity,1,0,0)
	if time_fraction>=0:
		# 2026-09-26: a slim timer bar tucked right under its own cube (was 15 tall at the
		# bottom of the tap target, touching the next row).
		var under := cube_rect() if depth_rendered else Rect2(Vector2(4,0),size-Vector2(8,10))
		var track:=Rect2(Vector2(under.position.x+4,under.end.y+3),Vector2(under.size.x-8,5))
		box(self,track.grow(1.5),Color("fff8e7"),4,tint.darkened(.55),1)
		box(self,track,tint.darkened(.64),3)
		# The coloured portion shrinks from left to right.
		var fraction:=clampf(time_fraction,0,1)
		var fill:=Rect2(track.position+Vector2(track.size.x*(1-fraction),0),Vector2(track.size.x*fraction,track.size.y))
		if fraction>0: box(self,fill,tint,3)
		# A tiny clock at the bar's end clarifies why the packet must wait.
		var clock:=Vector2(track.end.x+7,track.get_center().y)
		draw_circle(clock,5.5,Color("172a32"))
		draw_arc(clock,3.8,0,TAU,18,tint.lightened(.55),1.1,true)
		draw_line(clock,clock+Vector2(0,-2.6),Color.WHITE,1.0,true)
		draw_line(clock,clock+Vector2(2,.6),Color.WHITE,1.0,true)
