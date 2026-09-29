extends Control
## S4 archive: a stage card opens its pictures directly, without report prose.
const UI=preload("res://scripts/ui/museum_controls.gd")
const Kit=preload("res://scripts/ui/ui_kit.gd")
const Icon=preload("res://scripts/ui/museum_icon.gd")
const Catalog=preload("res://scripts/services/case_file_catalog.gd")
const Scene=preload("res://scripts/ui/stage_story_scene.gd")
const L=preload("res://scripts/services/localization.gd")
var game
var mode:="directory"
var stage_number:=1
var scene_index:=0
var rows:Array=[]
var directory_scroll:=0
var directory_focus:="LatestCase"

func setup(controller)->void:
	game=controller;set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter=Control.MOUSE_FILTER_STOP
	rows=Catalog.stages(game)
	resized.connect(_render);_render()

func _render()->void:
	if game==null:return
	for child in get_children():remove_child(child);child.queue_free()
	if mode=="reader":
		var row:Dictionary=rows[stage_number-1]
		var reader:=Scene.new();reader.name="Reader";add_child(reader)
		reader.setup(game,row.stage,row.scenes[scene_index],"Next scene" if scene_index+1<row.scenes.size() else "Back to cases",next_scene,_back,previous_scene,scene_index==0)
		return
	var bg:=Kit.image(self,"res://assets/backgrounds/museum_hall.png",Rect2(Vector2.ZERO,size))
	bg.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_COVERED;bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var shade:=ColorRect.new();shade.color=Color(.02,.06,.08,.6);shade.mouse_filter=Control.MOUSE_FILTER_IGNORE
	add_child(shade);shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var back:=UI.button(self,"",Rect2(24,20,76,64),_back)
	Icon.attach(back,"back","Safehouse",false,true);back.name="Back"
	UI.label(self,"CASE FILE",Rect2(124,14,472,72),42,Color("ffe5a0"),HORIZONTAL_ALIGNMENT_CENTER)
	UI.label(self,"Your story so far",Rect2(28,110,664,46),31,Color("ffe5a0"))
	var latest:=1
	for row in rows:
		if not row.scenes.is_empty():latest=int(row.stage.number)
	UI.button(self,"View latest case",Rect2(392,172,300,54),open_stage.bind(latest),false,22).name="LatestCase"
	var scroll:=ScrollContainer.new();scroll.name="Scroll";add_child(scroll)
	scroll.position=Vector2(28,250);scroll.size=Vector2(664,maxf(200,size.y-274))
	scroll.horizontal_scroll_mode=ScrollContainer.SCROLL_MODE_DISABLED
	var list:=VBoxContainer.new();list.name="Rows";scroll.add_child(list)
	list.size_flags_horizontal=Control.SIZE_EXPAND_FILL;list.add_theme_constant_override("separation",18)
	scroll.set_deferred("scroll_vertical",directory_scroll)
	scroll.get_v_scroll_bar().value_changed.connect(func(value):
		if mode=="directory":directory_scroll=roundi(value))
	for row in rows:
		var stage:Dictionary=row.stage
		var button:=UI.button(list,"",Rect2(0,0,648,224),open_stage.bind(int(stage.number)))
		button.name=stage.id;button.custom_minimum_size=Vector2(648,224);button.disabled=row.scenes.is_empty()
		if not row.scenes.is_empty():
			var picture:=Kit.image(button,row.scenes[0].image,Rect2(16,16,144,192))
			picture.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		else:Kit.icon(button,"lock",Vector2(88,108),30)
		UI.label(button,"STAGE %d · LEVELS %d–%d"%[stage.number,stage.first_level,stage.last_level],Rect2(180,20,438,28),17,Color("c9b58c"))
		var title:=UI.label(button,stage.title,Rect2(180,60,438,42),28,Color("ffe5a0"));L.fit(title,28,21)
		UI.label(button,"CASE COMPLETE" if row.completed else "IN PROGRESS" if row.unlocked else "LOCKED",Rect2(180,116,438,28),18,Color("38dbc3") if row.unlocked else Color("c9b58c"))
		UI.label(button,"Opening + Finale" if row.scenes.size()==2 else "Opening · %d / 10 artworks"%row.progress if row.scenes.size()==1 else "Scenes coming soon",Rect2(180,163,438,32),21,Color("fff0cb"))

func open_stage(number:int)->void:
	if number<1 or number>rows.size() or rows[number-1].scenes.is_empty():return
	if mode=="directory":
		var focus:=get_viewport().gui_get_focus_owner()
		if focus!=null and is_ancestor_of(focus):directory_focus=str(focus.name)
	stage_number=number;scene_index=0;mode="reader";_render();get_node("Reader/Next").grab_focus()

func previous_scene()->void:
	if mode=="reader" and scene_index>0:
		scene_index-=1;_render();get_node("Reader/Next").grab_focus()

func next_scene()->void:
	if mode!="reader":return
	if scene_index+1<rows[stage_number-1].scenes.size():
		scene_index+=1;_render();get_node("Reader/Next").grab_focus()
	else:_back()

func _back()->void:
	if mode=="reader":
		mode="directory";_render()
		var target:=get_node_or_null("LatestCase" if directory_focus=="LatestCase" else "Scroll/Rows/"+directory_focus)
		if target!=null:target.grab_focus()
	else:game._show_lobby()

func _unhandled_key_input(event:InputEvent)->void:
	if mode!="reader" or not game.modal_kind.is_empty() or not event is InputEventKey or not event.pressed or event.echo:return
	if event.keycode==KEY_LEFT:previous_scene();get_viewport().set_input_as_handled()
	elif event.keycode==KEY_RIGHT:next_scene();get_viewport().set_input_as_handled()
