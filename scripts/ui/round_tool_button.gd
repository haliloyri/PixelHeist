@tool
extends Button
const HV2 = preload("res://scripts/ui/game_theme.gd")
@export_enum("Undo","Sound","Help") var icon_kind := 0
## Gold booster-count badge; -1 (default) means "not a booster button" and no
## badge is drawn. Set from economy_service data when a button represents one;
## none of Undo/Sound/Help currently track a booster count, so they stay unbadged.
@export var badge_count := -1:
	set(value):
		badge_count = value
		queue_redraw()
## Painted icon (2026-09-25: the four toolbar icons cut from the reference mock-up).
## When set, the texture is the whole button face and the vector icon is skipped.
@export var icon_texture: Texture2D:
	set(value):
		icon_texture = value
		queue_redraw()
var muted := false
func _ready() -> void:
	mouse_default_cursor_shape=Control.CURSOR_POINTING_HAND
	for state in ["normal","hover","pressed","disabled","focus"]:add_theme_stylebox_override(state,StyleBoxEmpty.new())
	mouse_entered.connect(queue_redraw)
	mouse_exited.connect(queue_redraw)
	button_down.connect(queue_redraw)
	button_up.connect(queue_redraw)
func _draw() -> void:
	if icon_texture!=null:
		var face:=Rect2(Vector2(0,3 if is_pressed() else 0),size)
		var tint:=Color(1,1,1) if not is_hovered() else Color(1.08,1.08,1.08)
		draw_texture_rect(icon_texture,face,false,tint)
		if has_focus():draw_arc(size*.5,size.x*.47,0,TAU,40,Color.WHITE,3,true)
		_draw_badge(size*.5,size.x*.47)
		return
	# Vector icons were drawn for an 84 px button; scale them to the actual size.
	var k:=size.x/84.0
	draw_set_transform(Vector2.ZERO,0,Vector2.ONE*k)
	var center:=size/k*.5+Vector2(0,3 if is_pressed() else 0)
	var radius:=84.0*.47
	draw_circle(center+Vector2(0,5),radius,Color("766298"))
	draw_circle(center,radius,Color("a59bdd"))
	draw_circle(center-Vector2(0,2),radius-6,Color("e6e7fa"))
	draw_circle(center-Vector2(0,2),radius-11,Color("fff6e9"))
	draw_arc(center,radius-3,0,TAU,40,Color(1,1,1,.85),3,true)
	var color:=Color("8d7ca6") if disabled else Color("665895")
	if has_focus():draw_arc(center,radius-3,0,TAU,40,Color.WHITE,3,true)
	if icon_kind==0:
		draw_arc(center+Vector2(2,0),14,-PI*.65,PI*.85,24,color,5,true)
		draw_colored_polygon(PackedVector2Array([center+Vector2(-17,-12),center+Vector2(-16,3),center+Vector2(-3,-8)]),color)
	elif icon_kind==1:
		draw_colored_polygon(PackedVector2Array([center+Vector2(-17,-7),center+Vector2(-10,-7),center+Vector2(0,-15),center+Vector2(0,15),center+Vector2(-10,7),center+Vector2(-17,7)]),color)
		if muted:
			draw_line(center+Vector2(7,-8),center+Vector2(21,8),color,4,true)
			draw_line(center+Vector2(7,8),center+Vector2(21,-8),color,4,true)
		else:
			draw_arc(center,13,-.8,.8,15,color,3,true)
			draw_arc(center,22,-.8,.8,15,color,3,true)
	else:
		var font:=ThemeDB.fallback_font
		draw_string(font,center+Vector2(-10,13),"?",HORIZONTAL_ALIGNMENT_LEFT,-1,38,color)
	draw_set_transform(Vector2.ZERO)
	_draw_badge(size*.5,size.x*.47)

func _draw_badge(center:Vector2,radius:float)->void:
	if badge_count>=0:
		var badge_at:=center+Vector2(radius*.62,-radius*.62)
		var gold:=HV2.hv2_color("toolbar","badge_gold","#FFBD0D")
		draw_circle(badge_at,13,Color("2a2440"))
		draw_circle(badge_at,11,gold)
		var font:=ThemeDB.fallback_font
		var text:=str(badge_count)
		var font_size:=15
		var width:=font.get_string_size(text,HORIZONTAL_ALIGNMENT_LEFT,-1,font_size).x
		draw_string(font,badge_at+Vector2(-width*.5,font.get_ascent(font_size)*.5),text,HORIZONTAL_ALIGNMENT_LEFT,-1,font_size,Color("2a2440"))
