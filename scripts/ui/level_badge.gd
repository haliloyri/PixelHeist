@tool
extends Label
## "LEVEL {n}" plate at the top of the heist (ui.level_badge).
## 2026-09-26 redesign (Halil): no ribbon tails/arrows; a slim navy plate with a gold
## rim and small rivets, matching the museum wall and the painting's gold frame.
const HV2 = preload("res://scripts/ui/game_theme.gd")
func _ready() -> void:
	mouse_filter=Control.MOUSE_FILTER_IGNORE
	horizontal_alignment=HORIZONTAL_ALIGNMENT_CENTER
	vertical_alignment=VERTICAL_ALIGNMENT_CENTER
	# The engine's own Label text would draw on top of our plate; hide it and draw the
	# same text ourselves in _draw().
	add_theme_color_override("font_color",Color.TRANSPARENT)
	add_theme_color_override("font_shadow_color",Color.TRANSPARENT)
	resized.connect(queue_redraw)
func _draw() -> void:
	var gold:=Color("b89350")
	var deep:=Color("5e3a0c")
	var plate:=Rect2(Vector2.ZERO,size)
	var radius:=int(size.y*.34)
	var style:=StyleBoxFlat.new()
	style.set_corner_radius_all(radius)
	style.bg_color=Color(0,0,0,.32)
	draw_style_box(style,Rect2(plate.position+Vector2(0,3),plate.size))
	style=StyleBoxFlat.new()
	style.set_corner_radius_all(radius)
	style.bg_color=deep
	draw_style_box(style,plate)
	style=StyleBoxFlat.new()
	style.set_corner_radius_all(radius-2)
	style.bg_color=Color("151d35")
	style.border_color=gold
	style.set_border_width_all(2)
	draw_style_box(style,plate.grow(-2))
	var shine:=StyleBoxFlat.new()
	shine.set_corner_radius_all(radius-4)
	shine.bg_color=Color(1,1,1,.07)
	draw_style_box(shine,Rect2(plate.position+Vector2(6,5),Vector2(plate.size.x-12,plate.size.y*.38)))
	# Brass rivets at both ends.
	for x in [plate.position.x+13.0,plate.end.x-13.0]:
		draw_circle(Vector2(x,plate.get_center().y),3.2,deep)
		draw_circle(Vector2(x,plate.get_center().y),2.4,gold)
		draw_circle(Vector2(x-.7,plate.get_center().y-.7),.9,Color("fff0b8"))
	if text.is_empty():return
	var font: Font = preload("res://assets/fonts/Lora-700.ttf")
	var font_size := 25
	var width:=font.get_string_size(text,HORIZONTAL_ALIGNMENT_LEFT,-1,font_size).x
	var at:=Vector2((size.x-width)*.5,(size.y+font.get_ascent(font_size)-font.get_descent(font_size))*.5)
	draw_string_outline(font,at,text,HORIZONTAL_ALIGNMENT_LEFT,-1,font_size,1,Color("0d1226"))
	draw_string(font,at,text,HORIZONTAL_ALIGNMENT_LEFT,-1,font_size,Color("fff3d6"))
