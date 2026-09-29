@tool
extends Button
## Museum navy-and-brass pause button.
const HeistStyle = preload("res://scripts/ui/heist_skin.gd")
func _ready() -> void:
	text=""
	mouse_default_cursor_shape=Control.CURSOR_POINTING_HAND
	for state in ["normal","hover","pressed","disabled","focus"]:
		add_theme_stylebox_override(state,StyleBoxEmpty.new())
	mouse_entered.connect(queue_redraw)
	mouse_exited.connect(queue_redraw)
	button_down.connect(queue_redraw)
	button_up.connect(queue_redraw)
func _draw() -> void:
	var center:=size*.5+Vector2(0,3 if is_pressed() else 0)
	var radius:=size.x*.47
	var fill:=Color("151d35")
	if is_hovered():fill=fill.lightened(.08)
	draw_texture_rect(HeistStyle.region(Rect2(811,102,97,100)),Rect2(center-Vector2.ONE*radius,Vector2.ONE*radius*2),false,Color(1.1,1.1,1.1) if is_hovered() else Color.WHITE)
	var bar_height:=radius*.9
	for x in [-radius*.28,radius*.28]:
		var style:=StyleBoxFlat.new()
		style.bg_color=Color("f2e5ca")
		style.set_corner_radius_all(4)
		draw_style_box(style,Rect2(center+Vector2(x-radius*.13,-bar_height*.5),Vector2(radius*.26,bar_height)))
	if has_focus():draw_arc(center,radius+3,0,TAU,40,Color.WHITE,3,true)
