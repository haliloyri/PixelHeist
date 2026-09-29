@tool
extends ColorRect
## Slim brass progress pill; sibling fill/track retain the logical progress value.
func _ready() -> void:
	mouse_filter=Control.MOUSE_FILTER_IGNORE
	resized.connect(queue_redraw)
	call_deferred("_connect_siblings")
func _connect_siblings() -> void:
	var fill:=get_node_or_null("../ProgressFill")
	if fill!=null:fill.resized.connect(queue_redraw)
func _fraction() -> float:
	var track:=get_node_or_null("../ProgressTrack")
	var fill:=get_node_or_null("../ProgressFill")
	if track==null or fill==null or track.size.x<=0:return 0.0
	return clampf(fill.size.x/track.size.x,0,1)
func _draw() -> void:
	var fraction := _fraction()
	var fill := get_node_or_null("../ProgressFill")
	if fill != null and not fill.visible: fraction = 0.0
	var bar := Rect2(Vector2.ZERO,Vector2(size.x,8))
	var HeistStyle = preload("res://scripts/ui/heist_skin.gd")
	HeistStyle.panel(self,bar,Color("101c2b"),Color("9e773d"),4,1)
	if fraction > 0.0:
		HeistStyle.panel(self,Rect2(2,2,maxf(3,(size.x-4)*fraction),4),Color("d6ad68"),Color("f3d49a"),2,1)
