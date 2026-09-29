extends Control
## S1: approved museum/crew reference, with live progress and native hit targets.
const L = preload("res://scripts/services/localization.gd")
const Kit = preload("res://scripts/ui/ui_kit.gd")
const FACE = preload("res://assets/fonts/Lora-700.ttf")
const SCENE = preload("res://assets/lobby/v2/museum_simple.png")
const UI = preload("res://assets/lobby/v2/reference_ui.png")
const Navigation = preload("res://scripts/ui/home_navigation.gd")
const Controls=preload("res://scripts/ui/museum_controls.gd")
const MuseumIcon=preload("res://scripts/ui/museum_icon.gd")
const HomeArt=preload("res://scripts/ui/home_art.gd")
const StartButton=preload("res://scripts/ui/heist_start_button.gd")
const RewardArt=preload("res://scripts/ui/reward_art.gd")
const CUTOUT = preload("res://scripts/ui/lobby_cutout.gdshader")
const CREAM := Color("fff0cb")
const GOLD := Color("c6a16a")
const TEAL := Color("38dbc3")
const INK := Color("091720")
var game: Control
var nodes: Dictionary = {}
var placements: Array = []
var energy_value: Label
var energy_timer: Label
var gold_value: Label
var level_value: Label
var progress_value: Label
var stage_value: Label
var progress_dots: Array = []
var rewards: Control
var reward_buttons: Dictionary = {}
var rewards_panel:Panel
var shortcuts:Dictionary={}
var reward_return_focus:Control
var background_focus:Dictionary={}
var reduced := false

func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_STOP
	clip_contents = true
	resized.connect(_layout)

func setup(controller: Control) -> void:
	game = controller
	reduced = game.reduced_motion
	_build()
	refresh()
	_layout()
	_layout.call_deferred()

func _atlas(rect: Rect2) -> AtlasTexture:
	var texture := AtlasTexture.new()
	texture.atlas = UI
	texture.region = rect
	return texture

func _register(node: Control, rect: Rect2, bottom := false) -> void:
	placements.append([node, rect, bottom])
	node.position = rect.position
	node.size = rect.size

func _panel(rect: Rect2, bottom := false, fill: Color = INK, radius := 24) -> Panel:
	var panel := Panel.new()
	panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var style := Kit.panel_style(fill, GOLD.darkened(.2), 2, radius)
	style.border_blend = true
	panel.add_theme_stylebox_override("panel", style)
	add_child(panel)
	_register(panel, rect, bottom)
	return panel

func _label(text: String, rect: Rect2, font_size: int, bottom := false, color: Color = CREAM) -> Label:
	var label := Label.new()
	label.text = text
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	label.add_theme_font_override("font", FACE)
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", color)
	label.add_theme_color_override("font_outline_color", Color("071217"))
	label.add_theme_constant_override("outline_size", 2)
	add_child(label)
	_register(label, rect, bottom)
	return label

func _image(texture: Texture2D, rect: Rect2, bottom := false) -> TextureRect:
	var view := TextureRect.new()
	view.texture = texture
	view.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	view.stretch_mode = TextureRect.STRETCH_SCALE
	view.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(view)
	_register(view, rect, bottom)
	return view

func _hit(id: String, rect: Rect2, action: Callable, tooltip: String, bottom := false) -> Button:
	var button := Button.new()
	button.name = id
	button.tooltip_text = tooltip
	button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	for state in ["normal", "hover", "pressed", "disabled"]:
		button.add_theme_stylebox_override(state, StyleBoxEmpty.new())
	var focus := Kit.panel_style(Color(0,0,0,0), TEAL, 2, 20)
	focus.shadow_size = 0
	button.add_theme_stylebox_override("focus", focus)
	button.pressed.connect(action)
	add_child(button)
	_register(button, rect, bottom)
	nodes[id] = button
	return button

func _art_button(id: String, source: Rect2, rect: Rect2, action: Callable, tooltip: String, bottom := false) -> void:
	var view := _image(_atlas(source), rect, bottom)
	_clip_reference(view, 22 if id=="CaseFile" else rect.size.y*.5)
	var button := _hit(id, rect, action, tooltip, bottom)
	button.button_down.connect(func(): view.modulate = Color(.8,.9,.87))
	button.button_up.connect(func(): view.modulate = Color.WHITE)
	button.mouse_exited.connect(func(): view.modulate = Color.WHITE)

func _clip_reference(view: TextureRect, radius: float) -> void:
	var material := ShaderMaterial.new()
	material.shader = CUTOUT
	material.set_shader_parameter("extent",view.size)
	material.set_shader_parameter("radius",radius)
	material.set_shader_parameter("inset",1.5)
	view.material = material

func _build() -> void:
	# The title is part of the approved painting; no second title is overlaid.
	_image(SCENE, Rect2(0,0,720,1280)).name = "Background"
	_art_button("Avatar", Rect2(58,12,152,152), Rect2(44,9,116,116), func(): game._show_gallery("crew"), L.text("lobby.profile"))
	_panel(Rect2(449,29,174,44), false, Color("0d1b23"), 24)
	_clip_reference(_image(_atlas(Rect2(591,31,73,70)), Rect2(449,23,56,54)),27)
	gold_value = _label("", Rect2(502,30,113,42), 26)
	gold_value.name = "GoldValue"
	_hit("GoldHit", Rect2(449,23,176,54), func(): game._show_shop(), L.text("lobby.gold"))
	_art_button("Gear", Rect2(831,27,78,78), Rect2(636,21,60,60), func(): game._show_modal("settings"), L.text("ui.settings"))
	# Keep the existing energy economy visible without interrupting the central art.
	_panel(Rect2(188,31,147,43), false, Color("10252b"), 22)
	_label("♥", Rect2(193,33,37,37), 28, false, Color("e8b777"))
	energy_value = _label("", Rect2(231,32,97,40), 22)
	energy_value.name = "EnergyValue"
	energy_timer = _label("", Rect2(205,77,120,24), 16, false, GOLD)
	_hit("EnergyHit", Rect2(185,26,152,58), func(): game._show_modal("out_of_energy"), L.text("lobby.energy"))

	_panel(Rect2(36,862,500,110), true, Color("0c1920"), 26)
	level_value = _label("", Rect2(50,867,472,48), 34, true)
	level_value.name = "LevelValue"
	stage_value = _label("",Rect2(50,906,472,24),14,true,GOLD)
	for i in 10:
		var dot := _panel(Rect2(167+i*25,934,15,8), true, Color("10212b"), 4)
		progress_dots.append(dot)
	progress_value = _label("", Rect2(196,946,182,24), 19, true)
	progress_value.name = "ChapterProgress"
	var case_button:=_hit("CaseFile",Rect2(554,864,130,108),_open_case_file,L.text("lobby.case_file"),true)
	var case_art:=HomeArt.attach(case_button,"case_file",Rect2(15,0,100,84))
	Controls.label(case_button,L.text("lobby.case_file"),Rect2(0,83,130,25),18,CREAM,HORIZONTAL_ALIGNMENT_CENTER)
	case_button.button_down.connect(func():case_art.modulate=Color(.72,.85,.85))
	case_button.button_up.connect(func():case_art.modulate=Color.WHITE)
	case_button.mouse_exited.connect(func():case_art.modulate=Color.WHITE)
	_build_shortcuts()
	# Daily, Milestones and Star Chest already open the reward overview.
	var play:=StartButton.new();play.name="PlayButton"
	add_child(play);_register(play,Rect2(88,989,544,108),true)
	play.pressed.connect(func():game._play());nodes.PlayButton=play
	var footer:=Navigation.new()
	footer.name="HomeNav";footer.selected=1
	add_child(footer)
	_register(footer,Rect2(0,1134,720,146),true)
	var actions:=[func():game._show_shop(),func():_close_rewards(),func():game._show_gallery("paintings")]
	for i in 3:
		var rect:=Rect2([20,249,480][i],1140,[220,222,220][i],136)
		var button:=Navigation.add_hit(self,rect,L.text(["lobby.shop","lobby.home","lobby.museum"][i]),actions[i])
		button.name=["NavShop","NavSafehouse","NavGallery"][i]
		_register(button,rect,true)
		nodes[button.name]=button
	_build_rewards()

func _build_shortcuts()->void:
	var entries:=[
		["daily","Daily",Vector2(12,304)],
		["no_ads","No Ads",Vector2(12,490)],
		["chapter","Milestones",Vector2(12,676)],
		["coins","Watch Ad",Vector2(552,304)],
		["offer","Offers",Vector2(552,490)],
		["stars","Star Chest",Vector2(552,676)]]
	for entry in entries:
		var id:String=entry[0]
		var button:=_hit("Shortcut_"+id,Rect2(entry[2],Vector2(156,184)),_shortcut_pressed.bind(id),entry[1])
		RewardArt.attach(button,id,Rect2(4,0,148,138))
		var title:=Controls.label(button,entry[1],Rect2(4,137,148,25),17,CREAM,HORIZONTAL_ALIGNMENT_CENTER)
		title.add_theme_constant_override("outline_size",3)
		title.add_theme_color_override("font_outline_color",INK)
		var status:=Controls.label(button,"",Rect2(-2,162,160,22),17,CREAM,HORIZONTAL_ALIGNMENT_CENTER)
		status.name="Status";status.add_theme_constant_override("outline_size",4)
		status.add_theme_color_override("font_outline_color",INK)
		var badge:=Kit.panel(button,Rect2(124,8,26,26),TEAL,Color("fff0cb"),2,13)
		badge.name="Badge"
		Controls.label(badge,"!",Rect2(0,0,26,26),18,INK,HORIZONTAL_ALIGNMENT_CENTER)
		button.button_down.connect(func():button.get_node("Illustration").modulate=Color(.72,.85,.85))
		button.button_up.connect(func():button.get_node("Illustration").modulate=Color.WHITE)
		button.mouse_exited.connect(func():button.get_node("Illustration").modulate=Color.WHITE)
		shortcuts[id]=button

func _shortcut_pressed(id:String)->void:
	match id:
		"coins":game._watch_free_coins()
		"no_ads":game._show_modal("offer",{"product":"no_ads"})
		"offer":game._show_modal("offer")
		_:_open_rewards(id)

func _build_rewards() -> void:
	rewards=Control.new();rewards.name="RewardsTray"
	add_child(rewards);rewards.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	rewards.mouse_filter=Control.MOUSE_FILTER_STOP
	var dismiss:=Button.new();dismiss.name="Dismiss"
	var shade:=StyleBoxFlat.new();shade.bg_color=Color(.015,.03,.05,.86)
	for state in ["normal","hover","pressed"]:dismiss.add_theme_stylebox_override(state,shade)
	dismiss.focus_mode=Control.FOCUS_NONE
	rewards.add_child(dismiss);dismiss.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	dismiss.pressed.connect(_close_rewards)
	rewards_panel=Kit.panel(rewards,Rect2(36,100,648,1080),Color("102a35"),Color("edc77e"),3,26)
	rewards_panel.name="Panel";rewards_panel.mouse_filter=Control.MOUSE_FILTER_STOP
	Controls.label(rewards_panel,"Rewards",Rect2(28,22,480,48),38,Color("ffe5a0"))
	var close:=Controls.button(rewards_panel,"",Rect2(554,20,66,64),_close_rewards)
	MuseumIcon.attach(close,"close","Close rewards",false,true);close.name="Close"
	var hero:=Kit.panel(rewards_panel,Rect2(24,96,600,178),Color("163944"),Color("866947"),2,20)
	RewardArt.attach(hero,"daily",Rect2(8,0,178,178))
	Controls.label(hero,"Your next haul",Rect2(206,28,370,42),29,Color("ffe5a0"))
	Controls.label(hero,"Play. Collect. Make it yours.",Rect2(206,75,370,32),18,CREAM)
	Controls.label(rewards_panel,"",Rect2(230,218,360,30),18,TEAL).name="Summary"
	var actions:={"daily":func():game._open_daily(),"stars":func():game._open_star_chest(),"chapter":func():game._open_chapter_chest(),"coins":func():game._watch_free_coins(),"offer":func():game._show_modal("offer"),"no_ads":func():game._show_modal("offer",{"product":"no_ads"})}
	var i:=0
	for id in actions:
		var action:Callable=actions[id]
		var button:=Controls.button(rewards_panel,"",Rect2(24+(i%2)*308,294+(i/2)*246,292,232),func():_close_rewards();action.call())
		button.name=id.to_pascal_case()
		RewardArt.attach(button,id,Rect2(81,4,130,130))
		Controls.label(button,"",Rect2(8,136,276,28),23,CREAM,HORIZONTAL_ALIGNMENT_CENTER).name="Title"
		Controls.label(button,"",Rect2(8,168,276,24),16,Color("c9b58c"),HORIZONTAL_ALIGNMENT_CENTER).name="Status"
		Controls.label(button,"",Rect2(8,199,276,27),21,Color("ffe5a0"),HORIZONTAL_ALIGNMENT_CENTER).name="Action"
		reward_buttons[id]=button;i+=1
	rewards.hide()

func _refresh_rewards()->void:
	var store=game.store
	var daily:bool=store.daily_ready()
	var stars:int=store.star_chests_ready()
	var milestones:int=game.chapter_chest_count()
	var ads:int=store.free_coins_left()
	var next_milestone:=0
	for chapter in game.campaign.chapters:
		if not store.chapter_complete(chapter):next_milestone=int(chapter.number)*5;break
	_reward_row("daily","Daily reward","Ready to collect" if daily else "Back tomorrow","Collect" if daily else "Claimed",daily,daily)
	_reward_row("stars","Star chest","%d ready to open"%stars if stars>0 else "%d / %d stars"%[store.star_progress(),int(store.rules.stars_per_chest)],"Open" if stars>0 else "Locked",stars>0,stars>0)
	var milestone_status:="All milestones collected" if next_milestone==0 else "Complete Level %d"%next_milestone
	_reward_row("chapter","Milestone chest","%d ready to open"%milestones if milestones>0 else milestone_status,"Open" if milestones>0 else ("Complete" if next_milestone==0 else "Locked"),milestones>0,milestones>0)
	_reward_row("coins","Free coins","+%d gold · %d left today"%[int(store.rules.free_coins_gold),ads] if ads>0 else "Daily limit reached","Watch Ad" if ads>0 else "Tomorrow",ads>0,false)
	_reward_row("no_ads","No Ads","Interstitials removed" if store.no_ads() else "Keep optional rewarded ads","Owned" if store.no_ads() else "View",not store.no_ads(),false)
	_reward_row("offer","Offers","All packs collected" if game.featured_offer().is_empty() else "Gold, boosters & more","Owned" if game.featured_offer().is_empty() else "View",not game.featured_offer().is_empty(),false)
	var count:=int(daily)+stars+milestones
	rewards_panel.get_node("Summary").text=("1 reward ready" if count==1 else "%d rewards ready"%count) if count>0 else "More treasures ahead"
	rewards_panel.size.y=1054
	rewards_panel.position=Vector2(36,maxf(96,(size.y-rewards_panel.size.y)*.5))
	var focus:Array[Control]=[rewards_panel.get_node("Close")]
	for button in reward_buttons.values():
		if button.visible and not button.disabled:focus.append(button)
	for i in focus.size():
		focus[i].focus_next=focus[i].get_path_to(focus[(i+1)%focus.size()])
		focus[i].focus_previous=focus[i].get_path_to(focus[(i+focus.size()-1)%focus.size()])
	var statuses:={"daily":"Collect" if daily else "Tomorrow","stars":"Open · %d"%stars if stars>0 else "%d / %d ★"%[store.star_progress(),int(store.rules.stars_per_chest)],"chapter":"Open · %d"%milestones if milestones>0 else ("Complete" if next_milestone==0 else "Level %d"%next_milestone),"coins":"+%d · %d left"%[int(store.rules.free_coins_gold),ads] if ads>0 else "Tomorrow","no_ads":"Owned" if store.no_ads() else "View pack","offer":"View packs"}
	for id in shortcuts:
		var button:Button=shortcuts[id]
		button.get_node("Status").text=statuses[id]
		button.get_node("Badge").visible=bool(reward_buttons[id].get_meta("ready",false))
		button.tooltip_text=reward_buttons[id].tooltip_text
		button.disabled=(id=="coins" and ads<=0) or (id=="no_ads" and store.no_ads())
		button.visible=id!="offer" or not game.featured_offer().is_empty()
		button.modulate=Color(.7,.75,.77) if button.disabled else Color.WHITE

func _reward_row(id:String,title:String,status:String,action:String,enabled:bool,ready:bool)->void:
	var button:Button=reward_buttons[id]
	button.get_node("Title").text=title;button.get_node("Status").text=status;button.get_node("Action").text=action
	button.tooltip_text=title+" · "+status
	button.set_meta("accessible_label",button.tooltip_text+" · "+action)
	button.disabled=not enabled
	if not button.has_meta("ready") or button.get_meta("ready")!=ready:Controls.style(button,ready);button.set_meta("ready",ready)

func _toggle_rewards() -> void:
	if rewards.visible:_close_rewards();return
	_open_rewards()

func _open_rewards(id:String="")->void:
	if rewards.visible:return
	reward_return_focus=shortcuts.get(id,shortcuts.daily)
	_refresh_rewards()
	# Modal keyboard navigation cannot escape into the underlying Safehouse.
	background_focus.clear()
	for button in nodes.values():
		background_focus[button]=button.focus_mode
		button.focus_mode=Control.FOCUS_NONE
	rewards.show()
	var target:Control=reward_buttons.get(id,rewards_panel.get_node("Close"))
	if target is Button and target.disabled:target=rewards_panel.get_node("Close")
	target.grab_focus()

func _close_rewards()->void:
	rewards.hide()
	for button in background_focus:
		if is_instance_valid(button):button.focus_mode=background_focus[button]
	background_focus.clear()
	if is_instance_valid(reward_return_focus):reward_return_focus.grab_focus()

func _input(event:InputEvent)->void:
	if rewards!=null and rewards.visible and game.modal_kind.is_empty() and event.is_action_pressed("ui_cancel"):
		_close_rewards();get_viewport().set_input_as_handled()

func _open_case_file() -> void:
	game._show_story(0)
	game.screen_view.show_archive()

func _layout() -> void:
	for entry in placements:
		var rect: Rect2 = entry[1]
		var node: Control = entry[0]
		node.position = rect.position+Vector2(0,maxf(0,size.y-1280) if entry[2] else 0)
		node.size = rect.size
	# Spread the side controls through the extra portrait height as Play moves down.
	for id in shortcuts:
		var weight:float={"daily":0.0,"coins":0.0,"no_ads":.5,"offer":.5,"chapter":1.0,"stars":1.0}[id]
		shortcuts[id].position.y+=maxf(0,size.y-1280)*weight
	if rewards_panel!=null:rewards_panel.position=Vector2(36,maxf(96,(size.y-rewards_panel.size.y)*.5))
	queue_redraw()

func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO,size), Color("07131b"))

func refresh() -> void:
	if game == null: return
	var store = game.store
	store.regenerate()
	gold_value.text = L.number(int(store.state.gold))
	L.fit(gold_value,26,16)
	var index: int = game.next_index()
	nodes.PlayButton.set_available(index>=0,L.text("lobby.start_heist") if index>=0 else L.text("lobby.all_done"))
	level_value.text = L.text("ui.level_badge", {"n":L.number(game.heist_number(index))}) if index>=0 else L.text("lobby.all_done")
	L.fit(level_value,34,19)
	var progress: Dictionary = game.current_stage_progress()
	stage_value.text = "STAGE %d · %s" % [int(progress.stage.number),str(progress.stage.title).to_upper()]
	L.fit(stage_value,14,11)
	progress_value.text = "%d / 10" % int(progress.done)
	for i in 10:
		var style := Kit.panel_style(TEAL.darkened(.12) if i<int(progress.done) else Color("10212b"), TEAL.lightened(.3) if i<int(progress.done) else GOLD.darkened(.35), 1, 4)
		style.shadow_size = 0
		progress_dots[i].add_theme_stylebox_override("panel", style)
	_refresh_rewards()
	tick()

func tick() -> void:
	if game == null: return
	var store = game.store
	store.regenerate()
	energy_value.text = "∞" if store.unlimited_energy() else "%d/%d" % [int(store.state.energy),int(store.rules.energy_max)]
	if rewards!=null:_refresh_rewards()
	var seconds: int = store.seconds_to_next_energy()
	energy_timer.text = "" if seconds<=0 or store.unlimited_energy() else "%02d:%02d" % [seconds/60,seconds%60]
