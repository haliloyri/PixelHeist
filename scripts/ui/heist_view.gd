@tool
extends Control
const Layout=preload("res://scripts/ui/queue_layout.gd")
const Capsule = preload("res://scripts/ui/capsule_button.gd")
const Drone = preload("res://scripts/ui/drone_design.gd")
var game: Control
var preview: Dictionary = {}
var location_data: Array = []
func _ready() -> void:
	mouse_filter=Control.MOUSE_FILTER_IGNORE
	var data: Array=JSON.parse_string(FileAccess.get_file_as_string("res://data/levels.json"))
	preview=data[3]
	location_data=JSON.parse_string(FileAccess.get_file_as_string("res://data/locations.json"))
	queue_redraw()
func _draw() -> void:
	if preview.is_empty():return
	var level:Dictionary=game.current_level() if is_instance_valid(game) else preview
	var active:Array=game.puzzle.active if is_instance_valid(game) else [{},{},{}]
	var lanes:Array=game.puzzle.lanes if is_instance_valid(game) else preview.lanes
	var location: int=game.level_index if is_instance_valid(game) else 3
	var accent:=Color(location_data[location].slot_color)
	var count:int=game.puzzle.slot_count if is_instance_valid(game) else 3
	for slot in count:
		var point:=Layout.dock(slot,count)
		var capsule:Dictionary=active[slot]
		if not capsule.is_empty():
			var tint:=Color(level.palette[int(capsule.color)])
			var pose:Dictionary=game.carrier_pose(slot) if is_instance_valid(game) else {"position":point,"open":1.0}
			# Arms fold by default and fully open on first launch (pose.open); they also
			# begin a partial pre-open once the run is nearly spent, before that happens.
			var low_capacity_bias:=clampf((4.0-float(capsule.left))/4.0,0,1)*.6
			var arms:=maxf(float(pose.open),low_capacity_bias)
			Drone.paint(self,pose.position,Layout.carrier_radius(count),tint,-PI/2,int(capsule.left),1,float(Time.get_ticks_msec())*.012,arms)
		else:
			# Empty "waiting pad": no drone queued for this dock yet. Toy language -- a soft
			# pastel dish with a thick white rim and a dashed accent ring -- replacing the old
			# plain square-with-cross placeholder (heist-v2 follow-up, 2026-09-23 feedback:
			# "drone/box waiting-area design hasn't changed").
			var pad_w:=96.0 if count==5 else 116.0
			var pad_h:=pad_w*.6
			var pad:=Rect2(point-Vector2(pad_w,pad_h)*.5,Vector2(pad_w,pad_h))
			Capsule.box(self,Rect2(pad.position+Vector2(0,6),pad.size),Color(.24,.31,.30,.14),pad_h*.5)
			Capsule.box(self,pad,accent.lerp(Color.WHITE,.87),pad_h*.5,Color.WHITE,4)
			var ring_r:=pad_h*.4
			for i in 10:
				var a0:=TAU*float(i)/10.0
				draw_arc(point,ring_r,a0,a0+TAU/10.0*.6,6,accent.lightened(.1),3,true)
			draw_circle(point,4.5,accent.darkened(.08))
	for column in count:
		var lane:Array=lanes[column]
		for depth in [1,2]:
			if lane.size()<=depth:continue
			var rect:=Rect2(Layout.row(column,count,depth)-Vector2(49,30),Vector2(98,60))
			var packet:Dictionary=lane[depth]
			if packet.get("mystery",false):
				Capsule.paint_mystery(self,rect.get_center(),49)
			else:
				var tint:=Color(level.palette[int(packet.color)])
				Drone.paint(self,rect.get_center(),49,tint,-PI/2,int(packet.amount),1,0,0)
