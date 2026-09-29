@tool
extends Control
## Nine-slice ornament from the approved transparent atlas; live pixels stay separate.
const HeistStyle = preload("res://scripts/ui/heist_skin.gd")
@export var band := 20.0
func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	resized.connect(queue_redraw)
func _draw() -> void:
	var rect := Rect2(Vector2.ZERO,size)
	draw_rect(Rect2(Vector2(4,7),size),Color(0,0,0,.3))
	draw_rect(rect.grow(-band+2),Color("141a2b"))
	var frame := StyleBoxTexture.new()
	frame.texture = HeistStyle.region(Rect2(8,96,152,117))
	frame.draw_center = false
	for side in [SIDE_LEFT,SIDE_TOP,SIDE_RIGHT,SIDE_BOTTOM]: frame.set_texture_margin(side,24)
	draw_style_box(frame,rect)
