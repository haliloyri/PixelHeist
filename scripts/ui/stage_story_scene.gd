extends Control
## Shared, image-led S4 scene used by live Stage 1 and read-only Case File.
const UI=preload("res://scripts/ui/museum_controls.gd")
const Kit=preload("res://scripts/ui/ui_kit.gd")
const Icon=preload("res://scripts/ui/museum_icon.gd")
const SPEAKERS={"rocco":"Rocco","sprocket":"Sprocket"}
var game
var stage:Dictionary
var panel:Dictionary
var action_text:String
var action:Callable
var back_action:Callable
var previous_action:Callable
var previous_disabled:=false

func setup(controller,stage_info:Dictionary,scene:Dictionary,label:String,on_continue:Callable,on_back:Callable,on_previous:Callable=Callable(),disable_previous:=false)->void:
	game=controller;stage=stage_info;panel=scene;action_text=label;action=on_continue;back_action=on_back;previous_action=on_previous;previous_disabled=disable_previous
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	resized.connect(_render);_render()

func _render()->void:
	if game==null:return
	for child in get_children():remove_child(child);child.queue_free()
	var bg:=Kit.image(self,"res://assets/backgrounds/museum_hall.png",Rect2(Vector2.ZERO,size))
	bg.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_COVERED;bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var shade:=ColorRect.new();shade.color=Color(.02,.06,.08,.7);shade.mouse_filter=Control.MOUSE_FILTER_IGNORE
	add_child(shade);shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var back:=UI.button(self,"",Rect2(24,20,76,64),back_action)
	back.name="Back";Icon.attach(back,"back","Back to cases" if previous_action.is_valid() else "Safehouse",false,true)
	UI.label(self,"STAGE %d · %s"%[stage.number,str(panel.kind).to_upper()],Rect2(112,28,580,48),27,Color("ffe5a0"),HORIZONTAL_ALIGNMENT_CENTER)
	UI.label(self,stage.title,Rect2(24,98,672,40),30,Color("ffe5a0"),HORIZONTAL_ALIGNMENT_CENTER)
	var texture_size:=Kit.texture(panel.image).get_size()
	var available_height:=maxf(400,size.y-270)
	var frame_height:=minf(available_height,656*texture_size.y/texture_size.x+16)
	var frame:=Kit.panel(self,Rect2(24,154+(available_height-frame_height)*.5,672,frame_height),Color("102a35"),Color("edc77e"),2,18)
	frame.name="Scene"
	var art:=Kit.image(frame,panel.image,Rect2(8,8,656,frame.size.y-16))
	art.name="Artwork";art.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	# Anchor balloons to the contained image, including its letterbox offset.
	var image_size:=art.texture.get_size()
	var image_scale:=minf(art.size.x/image_size.x,art.size.y/image_size.y)
	var shown_size:=image_size*image_scale
	var dialogue:=Control.new()
	dialogue.name="SpeechBubbles";dialogue.mouse_filter=Control.MOUSE_FILTER_IGNORE
	art.add_child(dialogue)
	dialogue.position=(art.size-shown_size)*.5
	dialogue.scale=Vector2.ONE*(shown_size.x/656.0)
	dialogue.size=shown_size/dialogue.scale
	for i in panel.bubbles.size():
		var bubble:Dictionary=panel.bubbles[i]
		var bounds:Array=bubble.bounds
		var box:=SpeechBubble.new()
		box.name="Dialogue%d"%i;box.mouse_filter=Control.MOUSE_FILTER_IGNORE
		dialogue.add_child(box)
		box.position=Vector2(bounds[0],bounds[1]);box.size=Vector2(bounds[2],bounds[3])
		box.tail=Vector2(bubble.tail[0],bubble.tail[1])-box.position
		UI.label(box,SPEAKERS[bubble.speaker],Rect2(18,9,box.size.x-36,25),19,Color("a34429") if bubble.speaker=="rocco" else Color("176176"))
		UI.label(box,bubble.text,Rect2(18,36,box.size.x-36,box.size.y-47),24,Color("2a241d"),HORIZONTAL_ALIGNMENT_LEFT,true)
	if previous_action.is_valid():
		var previous:=UI.button(self,"Previous",Rect2(24,size.y-96,208,68),previous_action,false,23)
		previous.name="Previous";previous.disabled=previous_disabled
	UI.button(self,action_text,Rect2(250 if previous_action.is_valid() else 24,size.y-96,446 if previous_action.is_valid() else 672,68),action,true,25).name="Next"

class SpeechBubble extends Control:
	var tail:=Vector2.ZERO
	func _draw()->void:
		var fill:=Color("fff1d6")
		var ink:=Color("3c3027")
		var style:=Kit.panel_style(fill,ink,3,24)
		style.shadow_size=5;style.shadow_offset=Vector2(0,3)
		draw_style_box(style,Rect2(Vector2.ZERO,size))
		var base:=clampf(tail.x-14,36,size.x-36)
		var left:=Vector2(base-14,size.y-3)
		var right:=Vector2(base+14,size.y-3)
		draw_colored_polygon(PackedVector2Array([left,tail,right]),fill)
		draw_polyline(PackedVector2Array([Vector2(left.x,size.y-1.5),tail,Vector2(right.x,size.y-1.5)]),ink,3,true)
