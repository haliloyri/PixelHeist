@tool
extends Button
## Free 2X and timed gold-unlocked 3X. Only ants speed up.
const HV2 = preload("res://scripts/ui/game_theme.gd")
var multiplier:=1
var seconds:=0.0
var highlighted:=false
func _ready()->void:
	text=""
	mouse_default_cursor_shape=Control.CURSOR_POINTING_HAND
	for state in ["normal","hover","pressed","disabled","focus"]:
		add_theme_stylebox_override(state,StyleBoxEmpty.new())
	mouse_entered.connect(queue_redraw)
	mouse_exited.connect(queue_redraw)
	button_down.connect(queue_redraw)
	button_up.connect(queue_redraw)
func _draw()->void:
	var active:=highlighted
	var gold:=Color("e0a93a")
	var navy:=Color("1f2745")
	var rect:=Rect2(Vector2(0,2 if is_pressed() else 0),size)
	var radius:=int(size.y*.34)
	# Drop shadow, then the chip body with a lighter top half.
	var style:=StyleBoxFlat.new()
	style.set_corner_radius_all(radius)
	style.bg_color=Color(0,0,0,.32)
	draw_style_box(style,Rect2(rect.position+Vector2(0,3),rect.size))
	style=StyleBoxFlat.new()
	style.set_corner_radius_all(radius)
	style.set_border_width_all(2)
	style.border_color=Color("80dce8") if active else gold
	style.bg_color=Color("203d53") if active else navy
	if is_hovered(): style.bg_color=style.bg_color.lightened(.08)
	draw_style_box(style,rect)
	var shine:=StyleBoxFlat.new()
	shine.set_corner_radius_all(radius-3)
	shine.bg_color=Color(1,1,1,.28 if active else .08)
	draw_style_box(shine,Rect2(rect.position+Vector2(4,3),Vector2(rect.size.x-8,rect.size.y*.42)))
	if active:
		# Soft glow ring while fast.
		var ring:=StyleBoxFlat.new()
		ring.set_corner_radius_all(radius+3)
		ring.bg_color=Color.TRANSPARENT
		ring.border_color=Color(1,.84,.4,.45)
		ring.set_border_width_all(2)
		draw_style_box(ring,rect.grow(3))
	var ink:=Color("f2e5ca")
	# Two chevrons then the multiplier.
	var cy:=rect.get_center().y
	var x0:=rect.position.x+size.x*.17
	for offset in [0.0,7.0]:
		draw_colored_polygon(PackedVector2Array([Vector2(x0+offset,cy-6),Vector2(x0+offset+7,cy),Vector2(x0+offset,cy+6)]),ink if active or offset>0 else Color(ink,.55))
	var font: Font = preload("res://assets/fonts/Lora-700.ttf")
	var title:="%dX" % multiplier
	var font_size:=23
	var width:=font.get_string_size(title,HORIZONTAL_ALIGNMENT_LEFT,-1,font_size).x
	var at:=Vector2(rect.position.x+size.x*.60-width*.5,cy+font.get_ascent(font_size)*.5-font.get_descent(font_size)*.35-(5 if multiplier==3 else 0))
	draw_string(font,at,title,HORIZONTAL_ALIGNMENT_LEFT,-1,font_size,ink)
	if multiplier==3 and seconds>0:
		var remaining:="%d:%02d" % [int(seconds)/60,int(seconds)%60]
		var time_width:=font.get_string_size(remaining,HORIZONTAL_ALIGNMENT_LEFT,-1,11).x
		draw_string(font,Vector2(rect.position.x+size.x*.60-time_width*.5,cy+19),remaining,HORIZONTAL_ALIGNMENT_LEFT,-1,11,ink)
	if has_focus():
		var focus:=StyleBoxFlat.new()
		focus.set_corner_radius_all(radius)
		focus.bg_color=Color.TRANSPARENT
		focus.border_color=Color("fff7dc")
		focus.set_border_width_all(2)
		draw_style_box(focus,rect.grow(-3))
