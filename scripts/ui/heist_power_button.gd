@tool
extends Button
const HeistStyle = preload("res://scripts/ui/heist_skin.gd")
@export var kind := 0
var badge_count := -1
func _ready() -> void:
	mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	for state in ["normal","hover","pressed","disabled","focus"]: add_theme_stylebox_override(state,StyleBoxEmpty.new())
	mouse_entered.connect(queue_redraw)
	mouse_exited.connect(queue_redraw)
	button_down.connect(queue_redraw)
	button_up.connect(queue_redraw)
func _draw() -> void:
	var center := size*.5+Vector2(0,2 if is_pressed() else 0)
	var r := minf(size.x,size.y)*.47
	var plate := Rect2(center-Vector2.ONE*r,Vector2.ONE*r*2)
	draw_texture_rect(HeistStyle.region(Rect2(811,102,97,100)),plate,false,Color(1.13,1.13,1.13) if is_hovered() else Color.WHITE)
	var texture := HeistStyle.icon(kind)
	var extent := texture.get_size()
	extent *= (r*1.3)/maxf(extent.x,extent.y)
	draw_texture_rect(texture,Rect2(center-extent*.5,extent),false)
	if has_focus(): draw_arc(center,r+2,0,TAU,48,HeistStyle.ICE,2,true)
