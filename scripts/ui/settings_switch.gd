extends Button
## Native focus/keyboard semantics, with a drawn enamel switch and explicit state.
const FONT=preload("res://assets/fonts/Lora-700.ttf")
func _ready()->void:
	toggle_mode=true
	mouse_default_cursor_shape=Control.CURSOR_POINTING_HAND
	for state in ["normal","hover","pressed","disabled"]:add_theme_stylebox_override(state,StyleBoxEmpty.new())
	var focus:=StyleBoxFlat.new()
	focus.bg_color=Color.TRANSPARENT;focus.border_color=Color("38dbc3")
	focus.set_border_width_all(2);focus.set_corner_radius_all(16)
	add_theme_stylebox_override("focus",focus)
	toggled.connect(func(_on):queue_redraw())
func _draw()->void:
	var track:=StyleBoxFlat.new()
	track.bg_color=Color("087f72") if button_pressed else Color("263f48")
	track.border_color=Color("edc77e");track.set_border_width_all(2);track.set_corner_radius_all(24)
	draw_style_box(track,Rect2(4,10,size.x-8,48))
	var x:float=size.x-30 if button_pressed else 30
	draw_circle(Vector2(x,34),19,Color("71401c"))
	draw_circle(Vector2(x,32),18,Color("fff0cb"))
	draw_string(FONT,Vector2(18 if button_pressed else 59,40),"On" if button_pressed else "Off",HORIZONTAL_ALIGNMENT_LEFT,-1,20,Color("fff0cb"))
