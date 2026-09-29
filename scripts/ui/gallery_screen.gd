extends Control
## S5 Museum: ten named floors, a personal collection and a HUD-free photo mode.
const Kit=preload("res://scripts/ui/ui_kit.gd")
const L=preload("res://scripts/services/localization.gd")
const ArtView=preload("res://scripts/ui/museum_art.gd")
const Originals=preload("res://scripts/ui/heist_intro.gd")
const MuseumIcon=preload("res://scripts/ui/museum_icon.gd")
const Navigation=preload("res://scripts/ui/museum_navigation.gd")
const Controls=preload("res://scripts/ui/museum_controls.gd")
const Room=preload("res://scripts/ui/collection_room.gd")
const FONT=preload("res://assets/fonts/Lora-700.ttf")
var game
var tab:="paintings"
var floor_number:=1
var content:Control
var pixels:=false
var editing:=false
var photo_mode:=false
var portrait_photo:=false
var saving:=false
var picker:FileDialog
var floor_scroll_offset:=0
var floor_menu:Control
var floor_return_focus:Control
var selected_art:=""
var collection_scroll_offset:=0
var crew_scroll_offset:=0

func setup(controller,start_tab:String="paintings")->void:
	game=controller
	tab=start_tab
	floor_number=int(game.current_stage_progress().stage.number)
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter=Control.MOUSE_FILTER_STOP
	resized.connect(_resize)
	refresh()

func _resize()->void:
	if is_instance_valid(content): refresh.call_deferred()

func _label(text:String,rect:Rect2,font_size:=24)->Label:
	var label:=Kit.label(content,text,rect,font_size,Kit.CREAM,1)
	label.add_theme_font_override("font",FONT)
	label.clip_text=true
	label.size=rect.size
	L.fit(label,font_size,14)
	return label

func _button(text:String,rect:Rect2,action:Callable,primary:=false)->Button:
	var button:=Kit.button(content,text,rect,action,"green" if primary else "secondary",22)
	Controls.style(button,primary)
	return button

func _iconize(button:Button,kind:String,label:String,selected:=false)->Button:
	return MuseumIcon.attach(button,kind,label,selected,true)

func _icon_button(kind:String,rect:Rect2,action:Callable,label:String,selected:=false)->Button:
	return _iconize(_button("",rect,action,selected),kind,label,selected)

func refresh()->void:
	floor_menu=null
	# Detach immediately, so a rapid resize cannot leave duplicate controls intercepting input.
	for child in get_children(): remove_child(child);child.queue_free()
	var backdrop:=Kit.image(self,"res://assets/backgrounds/museum_hall.png",Rect2(Vector2.ZERO,size))
	backdrop.name="MuseumBackdrop"
	backdrop.modulate=Color(.80,.88,1.0)
	var shade:=ColorRect.new()
	shade.color=Color(.02,.04,.08,.20);shade.mouse_filter=Control.MOUSE_FILTER_IGNORE
	add_child(shade);shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	content=Control.new()
	content.name="Content"
	content.mouse_filter=Control.MOUSE_FILTER_IGNORE
	add_child(content)
	content.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	if photo_mode:
		_photo()
		return
	_icon_button("back",Rect2(24,20,76,64),_back,"Exit editing" if editing else "Back to Safehouse").name="MuseumBack"
	var heading:=_label(L.text("museum.title").to_upper(),Rect2(124,13,472,77),52)
	heading.name="MuseumTitle"
	heading.add_theme_color_override("font_color",Color("ffe5a0"))
	heading.add_theme_color_override("font_shadow_color",Color("71401c"))
	heading.add_theme_constant_override("shadow_offset_y",4)
	heading.add_theme_constant_override("outline_size",4)
	heading.add_theme_color_override("font_outline_color",Color("102331"))
	var top_nav:=Navigation.new()
	top_nav.name="MuseumTabs"
	top_nav.position=Vector2(24,95)
	top_nav.size=Vector2(672,110)
	top_nav.selected=["paintings","collection","crew"].find(tab)
	content.add_child(top_nav)
	for i in 3:
		var id:String=["paintings","collection","crew"][i]
		var kind:String=["floors","collection","crew"][i]
		var button:=Navigation.add_button(content,Rect2(28+i*224,98,216,102),kind,L.text("museum.tab_"+id),tab==id,_switch.bind(id))
		button.name="Tab_"+id
	match tab:
		"paintings":_paintings()
		"collection":
			if editing:_editor()
			else:_collection()
		"crew":_crew()

func _back()->void:
	if not game.modal_kind.is_empty():return
	if is_instance_valid(floor_menu):
		_close_floor_menu()
	elif photo_mode:
		photo_mode=false
		refresh()
	elif editing:
		var name_edit:=content.get_node_or_null("CollectionName")
		if name_edit is LineEdit:_rename(name_edit.text)
		editing=false
		selected_art=""
		collection_scroll_offset=0
		refresh()
	else:
		game._show_lobby()

func _switch(id:String)->void:
	tab=id
	editing=false
	selected_art=""
	collection_scroll_offset=0
	refresh()

func _toggle_pixels()->void:
	var corridor:=content.get_node_or_null("FloorCorridor")
	if corridor is ScrollContainer:floor_scroll_offset=corridor.scroll_vertical
	pixels=not pixels
	refresh()

func _paintings()->void:
	var stage:Dictionary=game.campaign.stage_by_number(floor_number)
	# One quiet toolbar: floor number, name and two actions. Counts live in the directory.
	Kit.panel(content,Rect2(32,229,48,42),Color("102a35"),Color("c6a16a"),1,12)
	var floor_label:=_label("%02d"%floor_number,Rect2(32,229,48,42),22)
	floor_label.add_theme_color_override("font_color",Color("edc77e"))
	var title:=_label(str(stage.title),Rect2(94,222,420,56),26)
	title.name="FloorTitle"
	title.add_theme_color_override("font_color",Color("ffe5a0"))
	title.add_theme_color_override("font_shadow_color",Color("493018"))
	title.add_theme_constant_override("shadow_offset_y",2)
	title.horizontal_alignment=HORIZONTAL_ALIGNMENT_LEFT
	_icon_button("original" if pixels else "pixels",Rect2(530,220,70,60),_toggle_pixels,L.text("museum.show_originals" if pixels else "museum.show_pixels"),pixels).name="ViewMode"
	_icon_button("elevator",Rect2(614,220,74,60),_open_floor_menu,"Choose floor").name="FloorPicker"
	var scroll:=ScrollContainer.new()
	scroll.name="FloorCorridor"
	scroll.vertical_scroll_mode=ScrollContainer.SCROLL_MODE_AUTO
	scroll.horizontal_scroll_mode=ScrollContainer.SCROLL_MODE_DISABLED
	content.add_child(scroll)
	scroll.position=Vector2(29,296)
	scroll.size=Vector2(662,maxf(240,size.y-308))
	var wall:=Control.new()
	wall.name="FloorGrid"
	wall.mouse_filter=Control.MOUSE_FILTER_PASS
	scroll.add_child(wall)
	var slots:Array=game.campaign.stage_slots(floor_number)
	var top:=12.0
	for row in 5:
		var specs:Array=[]
		var row_height:=0.0
		for col in 2:
			var slot:Dictionary=slots[row*2+col]
			var spec:Dictionary=_floor_art_size(str(slot.art_id))
			specs.append(spec)
			row_height=maxf(row_height,float(spec.height)+66.0)
		for col in 2:
			var index:=row*2+col
			var slot:Dictionary=slots[index]
			var spec:Dictionary=specs[col]
			_floor_tile(wall,slot,index,Vector2(4+col*326,top+(row_height-(float(spec.height)+66.0))*.5),spec)
		top+=row_height+25
	wall.custom_minimum_size=Vector2(650,top+12)
	_style_scroll(scroll)
	scroll.set_deferred("scroll_vertical",floor_scroll_offset)
	scroll.get_v_scroll_bar().value_changed.connect(func(value):floor_scroll_offset=roundi(value))

func _open_floor_menu()->void:
	if is_instance_valid(floor_menu):
		_close_floor_menu()
		return
	floor_return_focus=content.get_node("FloorPicker")
	floor_menu=Control.new()
	floor_menu.name="FloorMenu"
	content.add_child(floor_menu)
	floor_menu.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var dismiss:=Button.new()
	dismiss.name="Dismiss"
	dismiss.focus_mode=Control.FOCUS_NONE
	var shade:=StyleBoxFlat.new()
	shade.bg_color=Color(.01,.025,.04,.72)
	for state in ["normal","hover","pressed"]:dismiss.add_theme_stylebox_override(state,shade)
	floor_menu.add_child(dismiss)
	dismiss.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	dismiss.pressed.connect(_close_floor_menu)
	# Anchored beneath the right-hand elevator control, inside the S5 screen.
	var height:=minf(810,size.y-448)
	var panel:=Kit.panel(floor_menu,Rect2(88,294,600,height),Color("0b1c25"),Color("c6a16a"),2,22)
	panel.name="Directory"
	panel.mouse_filter=Control.MOUSE_FILTER_STOP
	var heading:=Kit.label(panel,"CHOOSE FLOOR",Rect2(24,14,450,40),25,Color("f6dba3"),0,HORIZONTAL_ALIGNMENT_LEFT)
	heading.add_theme_font_override("font",FONT)
	var close:=Kit.button(panel,"",Rect2(522,12,56,48),_close_floor_menu,"secondary",22)
	_iconize(close,"close","Close floor list")
	close.name="Close"
	for state in ["normal","hover","pressed","focus"]:
		var close_style:=Kit.panel_style(Color("16323b") if state=="hover" else Color("0b1c25"),Color("c6a16a"),1,14)
		close_style.shadow_size=0
		close.add_theme_stylebox_override(state,close_style)
	var hint:=Kit.label(panel,"%d / 100 collected"%game.store.state.completed.size(),Rect2(24,55,480,26),17,Color("bfa780"),0,HORIZONTAL_ALIGNMENT_LEFT)
	hint.add_theme_font_override("font",FONT)
	var scroll:=ScrollContainer.new()
	scroll.name="FloorList"
	panel.add_child(scroll)
	scroll.position=Vector2(16,94)
	scroll.size=Vector2(568,height-112)
	scroll.horizontal_scroll_mode=ScrollContainer.SCROLL_MODE_DISABLED
	var rows:=VBoxContainer.new()
	rows.name="Rows"
	rows.size_flags_horizontal=Control.SIZE_EXPAND_FILL
	rows.add_theme_constant_override("separation",8)
	scroll.add_child(rows)
	var selected_button:Button
	var focus_buttons:Array[Control]=[close]
	for entry in game.campaign.stages:
		var number:=int(entry.number)
		var active:=number==floor_number
		var row:=Button.new()
		row.name="Floor%d"%number
		row.custom_minimum_size=Vector2(540,62)
		row.mouse_default_cursor_shape=Control.CURSOR_POINTING_HAND
		row.tooltip_text="Floor %d · %s"%[number,str(entry.title)]
		for state in ["normal","hover","pressed","focus"]:
			var fill:=Color("12453f") if active else Color("122731")
			var border:=Color("38dbc3") if active or state=="focus" else Color("665d48")
			var style:=Kit.panel_style(fill.lightened(.06) if state=="hover" else fill,border,1,12)
			style.shadow_size=0
			row.add_theme_stylebox_override(state,style)
		rows.add_child(row)
		focus_buttons.append(row)
		row.pressed.connect(_select_floor.bind(number))
		var badge:=Kit.label(row,"%02d"%number,Rect2(10,8,48,46),24,Color("8af1df") if active else Color("edc77e"),0)
		badge.add_theme_font_override("font",FONT)
		var name_label:=Kit.label(row,str(entry.title),Rect2(74,7,370,29),21,Color("fff0cb"),0,HORIZONTAL_ALIGNMENT_LEFT)
		name_label.add_theme_font_override("font",FONT)
		var done:int=game.campaign.stage_progress(number,game.store.state.completed)
		Kit.label(row,"%d / 10 collected"%done,Rect2(74,35,370,20),15,Color("bfa780"),0,HORIZONTAL_ALIGNMENT_LEFT)
		if active:
			selected_button=row
			var mark:=MuseumIcon.new()
			mark.kind="done";mark.selected=true;mark.position=Vector2(481,16);mark.size=Vector2(30,30)
			row.add_child(mark)
	for i in focus_buttons.size():
		var current:Control=focus_buttons[i]
		current.focus_next=current.get_path_to(focus_buttons[(i+1)%focus_buttons.size()])
		current.focus_previous=current.get_path_to(focus_buttons[(i+focus_buttons.size()-1)%focus_buttons.size()])
		current.focus_neighbor_bottom=current.focus_next
		current.focus_neighbor_top=current.focus_previous
		current.focus_neighbor_left=current.get_path_to(current)
		current.focus_neighbor_right=current.get_path_to(current)
	_style_scroll(scroll)
	if selected_button!=null:
		selected_button.grab_focus()
		scroll.ensure_control_visible.call_deferred(selected_button)

func _close_floor_menu()->void:
	if is_instance_valid(floor_menu):
		content.remove_child(floor_menu)
		floor_menu.queue_free()
	floor_menu=null
	if is_instance_valid(floor_return_focus):floor_return_focus.grab_focus()

func _select_floor(number:int)->void:
	floor_number=clampi(number,1,10)
	floor_scroll_offset=0
	refresh()
	content.get_node("FloorPicker").grab_focus()

func _input(event:InputEvent)->void:
	if is_instance_valid(floor_menu) and event.is_action_pressed("ui_cancel"):
		_close_floor_menu()
		get_viewport().set_input_as_handled()

func _style_scroll(scroll:ScrollContainer)->void:
	var bar:=scroll.get_v_scroll_bar()
	var track:=Kit.panel_style(Color("0b1821"),Color("0b1821"),0,4)
	track.shadow_size=0
	bar.add_theme_stylebox_override("scroll",track)
	for state in ["grabber","grabber_highlight","grabber_pressed"]:
		var thumb:=Kit.panel_style(Color("9d855c") if state=="grabber" else Color("dcc492"),Color("dcc492"),0,4)
		thumb.shadow_size=0
		thumb.content_margin_left=4
		thumb.content_margin_right=4
		bar.add_theme_stylebox_override(state,thumb)

func _floor_art_size(id:String)->Dictionary:
	if id.is_empty():return {"width":258.0,"height":226.0}
	var texture:Texture2D=Originals.artwork_texture(id)
	var level:Dictionary=game.level_for(id)
	var source:=Vector2(float(level.get("width",1)),float(level.get("height",1)))
	if (not pixels or level.is_empty()) and texture!=null:source=texture.get_size()
	var scale_factor:=minf(280.0/source.x,280.0/source.y)
	return {"width":source.x*scale_factor,"height":source.y*scale_factor}

func _floor_tile(wall:Control,slot:Dictionary,index:int,at:Vector2,spec:Dictionary)->void:
	var id:String=slot.art_id
	var frame:=Control.new()
	frame.name="Frame%d"%index
	frame.position=at
	frame.size=Vector2(310,float(spec.height)+66)
	frame.mouse_filter=Control.MOUSE_FILTER_PASS
	wall.add_child(frame)
	var art_width:float=spec.width
	var art_height:float=spec.height
	var art_left:float=(310.0-art_width)*.5
	if id.is_empty():
		Kit.panel(frame,Rect2(art_left,0,art_width,art_height),Color("0b1924"),Color("6d604c"),2,3)
		Kit.label(frame,L.text("museum.coming_soon"),Rect2(art_left+8,art_height*.37,art_width-16,52),19,Kit.MUTED,0)
	else:
		var art:=ArtView.new()
		frame.add_child(art)
		art.position=Vector2(art_left,0)
		art.setup(game,id,pixels,Vector2(art_width,art_height),false)
		var title:=Kit.label(frame,game.art_title(id),Rect2(0,art_height+10,310,29),21,Color("f4e8cf"),1)
		title.add_theme_font_override("font",FONT)
		L.fit(title,21,14)
	if not id.is_empty() and not game.store.state.completed.has(id) or id.is_empty():
		var badge:=Kit.panel(frame,Rect2(art_left+art_width-42,4,38,38),Color("0b1924"),Color("c6a16a"),2,19)
		Kit.icon(badge,"lock",Vector2(19,19),13)
	Kit.label(frame,("LEVEL %d"%int(slot.level))+(" · Original" if pixels and game.level_for(id).is_empty() and not id.is_empty() else ""),Rect2(0,art_height+39,310,23),17,Color("c6a16a"),0)
	if not id.is_empty():
		var hit:=Button.new()
		hit.name="Open"
		hit.flat=true
		hit.focus_mode=Control.FOCUS_ALL
		hit.mouse_default_cursor_shape=Control.CURSOR_POINTING_HAND
		hit.tooltip_text=game.art_title(id)
		for state in ["normal","hover","pressed","disabled"]:hit.add_theme_stylebox_override(state,StyleBoxEmpty.new())
		frame.add_child(hit)
		hit.position=Vector2(art_left,0)
		hit.size=Vector2(art_width,art_height)
		hit.pressed.connect(game.open_painting.bind(id))

func _floor(step:int)->void:
	floor_number=clampi(floor_number+step,1,10)
	floor_scroll_offset=0
	refresh()

func _collection()->void:
	var collection:Dictionary=game.store.collection()
	var heading:=_label(Room.LAYOUTS[collection.layout],Rect2(32,223,490,44),24)
	heading.horizontal_alignment=HORIZONTAL_ALIGNMENT_LEFT
	_label("%d / 10"%collection.art_ids.size(),Rect2(556,223,132,44),22)
	_collection_wall(collection,280,size.y-408,false)
	# Dedicated action shelf with a bottom inset, separate from the scrolling room.
	var y:=size.y-100
	_icon_button("edit",Rect2(48,y,184,72),func():editing=true;collection_scroll_offset=0;refresh(),L.text("museum.edit")).name="EditCollection"
	_icon_button("photo",Rect2(268,y,184,72),func():photo_mode=true;refresh(),L.text("museum.photo_mode"),true).name="PhotoMode"
	_icon_button("original" if pixels else "pixels",Rect2(488,y,184,72),_toggle_pixels,L.text("museum.show_originals" if pixels else "museum.show_pixels"),pixels).name="ViewMode"

func _collection_wall(collection:Dictionary,top:float,height:float,edit:bool)->void:
	var scroll:=ScrollContainer.new()
	scroll.name="CollectionScroll"
	content.add_child(scroll)
	scroll.position=Vector2(32,top);scroll.size=Vector2(656,maxf(120,height))
	scroll.horizontal_scroll_mode=ScrollContainer.SCROLL_MODE_DISABLED
	var body:=Control.new()
	body.name="CollectionBody"
	body.mouse_filter=Control.MOUSE_FILTER_PASS
	scroll.add_child(body)
	var room_height:=Room.live_height(collection.art_ids.size(),collection.layout,640)
	var room:=Room.new();body.add_child(room)
	room.name="CollectionRoom"
	room.setup(game,collection,pixels,Vector2(640,room_height),edit,selected_art)
	if edit:room.artwork_pressed.connect(_place_art)
	var total:=room_height
	if edit:
		var available:Array=[]
		for id in game.campaign.order():
			if game.store.state.completed.has(id) and not collection.art_ids.has(id):available.append(id)
		var label:=Kit.label(body,"ADD FROM YOUR MUSEUM",Rect2(12,total+28,616,42),25,Color("ffe5a0"),1,HORIZONTAL_ALIGNMENT_LEFT)
		label.add_theme_font_override("font",FONT)
		total+=90
		if available.is_empty():
			Kit.label(body,"Win more heists to collect new artwork.",Rect2(16,total,608,70),22,Kit.CREAM,0,HORIZONTAL_ALIGNMENT_CENTER,true)
			total+=90
		for i in available.size():
			var id:String=available[i]
			var card:=Kit.panel(body,Rect2(6+(i%2)*322,total+(i/2)*302,306,286),Color("102a35"),Color("c6a16a"),2,14)
			var art:=ArtView.new();card.add_child(art);art.position=Vector2(12,8);art.setup(game,id,pixels,Vector2(282,194))
			var add:=Kit.button(card,"",Rect2(109,214,88,58),_select.bind(id),"secondary",20)
			Controls.style(add,true)
			_iconize(add,"add",L.text("museum.add_collection"),true)
			add.name="Select_"+id
			add.disabled=collection.art_ids.size()>=10
			if add.disabled:add.tooltip_text="Collection full. Remove a painting first."
		total+=ceili(available.size()/2.0)*302
	body.custom_minimum_size=Vector2(640,total+16)
	_style_scroll(scroll)
	scroll.set_deferred("scroll_vertical",collection_scroll_offset)
	scroll.get_v_scroll_bar().value_changed.connect(func(value):collection_scroll_offset=roundi(value))

func _editor()->void:
	var collection:Dictionary=game.store.collection()
	if not collection.art_ids.has(selected_art):selected_art=""
	var name_edit:=LineEdit.new()
	name_edit.name="CollectionName"
	name_edit.text=collection.title;name_edit.max_length=32
	name_edit.add_theme_font_override("font",FONT)
	name_edit.add_theme_font_size_override("font_size",22)
	name_edit.add_theme_color_override("font_color",Color("fff0cb"))
	var field_style:=Kit.panel_style(Color("102a35"),Color("c6a16a"),2,14)
	field_style.content_margin_left=14;field_style.content_margin_right=14
	name_edit.add_theme_stylebox_override("normal",field_style)
	content.add_child(name_edit);name_edit.position=Vector2(32,226);name_edit.size=Vector2(486,56)
	name_edit.text_submitted.connect(func(value):_rename(value))
	name_edit.focus_exited.connect(func():
		if is_instance_valid(name_edit):_rename(name_edit.text))
	_icon_button("done",Rect2(548,226,140,56),_back,L.text("museum.done"),true).name="DoneEditing"
	for i in Room.LAYOUTS.size():
		var id:String=Room.LAYOUTS.keys()[i]
		_icon_button("layout_"+id,Rect2(32+i*96,302,80,62),_choose_layout.bind(id),Room.LAYOUTS[id],collection.layout==id).name="Layout_"+id
	var layout_label:=_label(Room.LAYOUTS[collection.layout],Rect2(322,301,218,64),21)
	layout_label.horizontal_alignment=HORIZONTAL_ALIGNMENT_LEFT
	_icon_button("palette",Rect2(592,302,96,62),_cycle_theme,"Room theme: "+L.text("museum.theme_"+str(collection.theme))+". Tap to change.").name="RoomTheme"
	var hint:=_label("Tap a painting, then another to swap their places.",Rect2(32,378,656,32),19)
	hint.horizontal_alignment=HORIZONTAL_ALIGNMENT_LEFT
	_collection_wall(collection,424,size.y-586,true)
	var y:=size.y-138
	var selection_title:="Select a painting to arrange it" if selected_art.is_empty() else "%d. %s"%[collection.art_ids.find(selected_art)+1,game.art_title(selected_art)]
	var selected_label:=_label(selection_title,Rect2(32,y,520,32),21)
	selected_label.horizontal_alignment=HORIZONTAL_ALIGNMENT_LEFT
	_label("%d / 10"%collection.art_ids.size(),Rect2(570,y,118,32),20)
	var index:int=collection.art_ids.find(selected_art)
	var previous:=_icon_button("left",Rect2(32,y+46,128,64),_move.bind(selected_art,-1),"Move earlier")
	previous.name="MoveEarlier";previous.disabled=index<=0
	var next:=_icon_button("right",Rect2(208,y+46,128,64),_move.bind(selected_art,1),"Move later")
	next.name="MoveLater";next.disabled=index<0 or index>=collection.art_ids.size()-1
	var feature:=_icon_button("feature",Rect2(384,y+46,128,64),_feature.bind(selected_art),"Move to first position")
	feature.name="MoveFirst";feature.disabled=index<=0
	var remove:=_icon_button("remove",Rect2(560,y+46,128,64),_select.bind(selected_art),L.text("museum.remove_collection"))
	remove.name="RemoveSelected";remove.disabled=index<0

func _choose_layout(id:String)->void:
	var c:Dictionary=game.store.collection()
	c.layout=id
	if _save(c):collection_scroll_offset=0;refresh()

func _cycle_theme()->void:
	var c:Dictionary=game.store.collection()
	_choose_theme((Room.THEMES.keys().find(c.theme)+1)%Room.THEMES.size())

func _place_art(id:String)->void:
	if selected_art.is_empty():
		selected_art=id
	elif selected_art==id:
		selected_art=""
	else:
		var c:Dictionary=game.store.collection()
		var source:int=c.art_ids.find(selected_art)
		var destination:int=c.art_ids.find(id)
		if source<0 or destination<0:return
		c.art_ids[source]=id;c.art_ids[destination]=selected_art
		c.featured=""
		if _save(c):selected_art=""
	refresh()

func _save(value:Dictionary)->bool:
	if game.store.save_collection(value):return true
	game.toast("museum.save_failed");return false
func _choose_theme(index:int)->void:
	var c:Dictionary=game.store.collection()
	c.theme=Room.THEMES.keys()[index]
	if _save(c):refresh()
func _rename(value:String)->void:
	var c:Dictionary=game.store.collection()
	var title:=value.strip_edges()
	if title==c.title:return
	if title.is_empty():title=L.text("museum.default_title")
	c.title=title
	if _save(c):
		var caption:=content.get_node_or_null("CollectionScroll/CollectionBody/CollectionRoom/CollectionTitle")
		if caption is Label:
			caption.text=title
			L.fit(caption,30,20)
	else:
		var input:=content.get_node_or_null("CollectionName")
		if input is LineEdit:input.text=game.store.collection().title
func _select(id:String)->void:
	if not game.store.toggle_collection(id):game.toast("museum.collection_full" if game.store.collection().art_ids.size()>=10 else "museum.save_failed")
	refresh()
func _feature(id:String)->void:
	var c:Dictionary=game.store.collection()
	if not c.art_ids.has(id):return
	c.art_ids.erase(id);c.art_ids.push_front(id);c.featured=id
	if _save(c):collection_scroll_offset=0
	refresh()
func _move(id:String,offset:int)->void:
	if not game.store.move_collection(id,offset):game.toast("museum.save_failed")
	refresh()

func _photo()->void:
	_icon_button("back",Rect2(24,20,112,60),_back,L.text("museum.back")).name="PhotoBack"
	var format_label:="9:16" if portrait_photo else "4:5"
	_icon_button("crop",Rect2(173,20,112,60),func():portrait_photo=not portrait_photo;refresh(),"Image format: "+format_label).name="PhotoFormat"
	_label(format_label,Rect2(287,20,82,60),18)
	_icon_button("original" if pixels else "pixels",Rect2(377,20,112,60),_toggle_pixels,L.text("museum.show_originals" if pixels else "museum.show_pixels"),pixels).name="ViewMode"
	var save:=_icon_button("save",Rect2(520,20,176,60),_choose_export,L.text("museum.save_png"),true)
	save.name="SavePNG";save.disabled=saving or game.store.collection().art_ids.is_empty()
	var extent:=photo_size()
	var available:=Vector2(672,maxf(800,size.y-180))
	var factor:=minf(available.x/extent.x,available.y/extent.y)
	var room:=Room.new();content.add_child(room)
	room.position=Vector2((720-extent.x*factor)*.5,110)
	room.setup(game,game.store.collection(),pixels,extent)
	room.scale=Vector2.ONE*factor
	room.name="PhotoPreview"
	_label(L.text("museum.export_hint"),Rect2(40,size.y-58,640,38),17)

func photo_size()->Vector2:
	return Vector2(1080,1920 if portrait_photo else 1350)

func _choose_export()->void:
	picker=FileDialog.new()
	picker.file_mode=FileDialog.FILE_MODE_SAVE_FILE
	picker.access=FileDialog.ACCESS_FILESYSTEM
	picker.use_native_dialog=true
	picker.add_filter("*.png","PNG image")
	picker.current_file="PixelHeist-Collection.png"
	picker.title=L.text("museum.save_png")
	add_child(picker)
	picker.file_selected.connect(_export_selected)
	picker.canceled.connect(func():picker.queue_free())
	picker.popup_centered_ratio(.8)

func _export_selected(path:String)->void:
	if is_instance_valid(picker):picker.queue_free()
	saving=true
	var error:int=await export_photo(path)
	saving=false
	game.toast("museum.export_saved" if error==OK else "museum.save_failed")

## Render only the room, never the controls, private state or OS interface.
func export_photo(path:String)->Error:
	if game.store.collection().art_ids.is_empty():return ERR_INVALID_DATA
	var snapshot:Dictionary=game.store.collection()
	var viewport:=SubViewport.new()
	viewport.size=Vector2i(photo_size())
	viewport.disable_3d=true
	viewport.render_target_update_mode=SubViewport.UPDATE_ALWAYS
	add_child(viewport)
	var room:=Room.new();viewport.add_child(room)
	room.setup(game,snapshot,pixels,photo_size())
	await get_tree().process_frame
	await get_tree().process_frame
	RenderingServer.force_draw(false)
	var image:=viewport.get_texture().get_image()
	var error:=ERR_CANT_CREATE if image==null or image.is_empty() else image.save_png(path)
	viewport.queue_free()
	return error

func _crew() -> void:
	var unlocked:Array=game.store.unlocked_crew()
	var equipped:String=str(game.store.state.crew.get("equipped",""))
	var heading:=_label("YOUR CREW",Rect2(32,224,450,38),25)
	heading.horizontal_alignment=HORIZONTAL_ALIGNMENT_LEFT
	_label("%d / %d"%[unlocked.size(),game.campaign.crew.size()],Rect2(540,224,148,38),22)
	var hint:=_label("Meet your crew. Choose who comes along.",Rect2(32,268,656,32),20)
	hint.horizontal_alignment=HORIZONTAL_ALIGNMENT_LEFT
	var scroll:=ScrollContainer.new();scroll.name="CrewScroll"
	content.add_child(scroll);scroll.position=Vector2(28,318);scroll.size=Vector2(664,maxf(240,size.y-334))
	scroll.horizontal_scroll_mode=ScrollContainer.SCROLL_MODE_DISABLED
	var rows:=VBoxContainer.new();rows.name="Rows";rows.size_flags_horizontal=Control.SIZE_EXPAND_FILL
	rows.add_theme_constant_override("separation",18);scroll.add_child(rows)
	for entry in game.campaign.crew:
		var open:bool=unlocked.has(entry.id)
		var active:bool=entry.id==equipped
		var card:=Panel.new();card.custom_minimum_size=Vector2(640,228)
		card.mouse_filter=Control.MOUSE_FILTER_PASS
		card.add_theme_stylebox_override("panel",Kit.panel_style(Color("123e3c") if active else Color("102a35"),Color("38dbc3") if active else Color("9d855c"),2,20))
		card.name="Crew_"+str(entry.id);rows.add_child(card)
		var portrait:=preload("res://scripts/ui/crew_portrait.gd").new()
		card.add_child(portrait);portrait.position=Vector2(14,30);portrait.size=Vector2(184,170);portrait.setup(entry.id,open)
		Controls.label(card,entry.name,Rect2(214,20,400,40),30,Color("ffe5a0"))
		Controls.label(card,entry.bio,Rect2(214,68,400,58),21,Color("fff0cb") if open else Color("b5bdb5"),HORIZONTAL_ALIGNMENT_LEFT,true)
		if open:
			var equip:=Controls.button(card,"Equipped" if active else "Equip",Rect2(214,148,398,60),_equip.bind(entry.id),not active,23)
			equip.name="Equip";equip.disabled=active
			equip.tooltip_text="Equipped: "+entry.name if active else "Equip "+entry.name
		else:
			Kit.icon(card,"lock",Vector2(232,178),16)
			Controls.label(card,L.text("museum.crew_unlock",{"n":game.campaign.crew_chapter(entry.id)*5}),Rect2(264,148,348,60),21,Color("c9b58c"))
	_style_scroll(scroll)
	scroll.set_deferred("scroll_vertical",crew_scroll_offset)
	scroll.get_v_scroll_bar().value_changed.connect(func(value):crew_scroll_offset=roundi(value))

func _equip(id:String)->void:
	if not game.store.equip_crew(id):game.toast("museum.save_failed")
	refresh()
