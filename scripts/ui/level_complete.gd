extends Control
## S3: a committed win celebrated once; Continue never waits for the animation.
const Kit=preload("res://scripts/ui/ui_kit.gd")
const UI=preload("res://scripts/ui/museum_controls.gd")
const L=preload("res://scripts/services/localization.gd")
const Art=preload("res://scripts/ui/museum_art.gd")
const Confetti=preload("res://scripts/ui/victory_confetti.gd")
const Portrait=preload("res://scripts/ui/crew_portrait.gd")
const SPEAKERS={"rocco":"Rocco","sprocket":"Sprocket","tuck":"Tuck","quill":"Quill","frost":"Mr. Frost","glimmer":"Baron Glimmer"}
var game
var win:Dictionary={}
var card:Panel
var frame:Control
var portraits:TextureRect
var gold_label:Label
var double_button:Button
var museum_button:Button
var continue_button:Button
var confetti:Control
var stars:Array[Control]=[]
var celebration_age:=0.0
var reduced:=false
var action_y:=0.0
var portrait_origin:=Vector2.ZERO
var full_card_height:=1088.0

func setup(controller,result:Dictionary)->void:
	game=controller;win=result;reduced=game.reduced_motion
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter=Control.MOUSE_FILTER_STOP
	var background:=Kit.image(self,"res://assets/backgrounds/museum_hall.png",Rect2(Vector2.ZERO,size))
	background.name="Background";background.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_COVERED
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var shade:=ColorRect.new();shade.color=Color(.015,.03,.05,.65);shade.mouse_filter=Control.MOUSE_FILTER_IGNORE
	add_child(shade);shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var crew_id:String=str(win.get("crew",""))
	var extra:=96 if not crew_id.is_empty() else 0
	full_card_height=1088+extra
	card=Kit.panel(self,Rect2(28,24,664,full_card_height),Color("102a35"),Color("edc77e"),3,28)
	card.name="VictoryCard";card.mouse_filter=Control.MOUSE_FILTER_STOP
	UI.label(card,L.text("complete.title"),Rect2(20,24,624,58),42,Color("ffe5a0"),HORIZONTAL_ALIGNMENT_CENTER).name="Title"
	var art_id:String=str(win.get("art_id",""))
	UI.label(card,"LEVEL %d  ·  HEIST SUCCESSFUL"%game.campaign.level_number(art_id),Rect2(28,85,608,30),18,Color("c9b58c"),HORIZONTAL_ALIGNMENT_CENTER)
	for i in 3:
		var star:=Kit.icon(card,"star",Vector2(232+i*100,151-(8 if i==1 else 0)),37 if i==1 else 31)
		star.filled=i<int(win.get("stars",1));star.name="Star%d"%i
		star.pivot_offset=star.size*.5;stars.append(star)
	frame=Art.new();frame.name="Frame";card.add_child(frame)
	frame.position=Vector2(172,202);frame.setup(game,art_id,true,Vector2(320,286),false)
	frame.pivot_offset=frame.size*.5
	portraits=Kit.image(card,"res://assets/ui/complete/victory_duo.png",Rect2(22,402,620,244))
	portraits.name="CelebratingCrew";portrait_origin=portraits.position
	UI.label(card,game.art_title(art_id),Rect2(28,654,608,42),28,Color("ffe5a0"),HORIZONTAL_ALIGNMENT_CENTER).name="ArtworkTitle"
	L.fit(card.get_node("ArtworkTitle"),28,18)
	var bubble:Dictionary=game.campaign.win_bubble(art_id)
	if not bubble.is_empty():
		var box:=Kit.panel(card,Rect2(28,710,608,92),Color("163944"),Color("496263"),1,18)
		box.name="Bubble"
		UI.label(box,SPEAKERS.get(bubble.speaker,bubble.speaker),Rect2(20,8,568,25),18,Color("ffe5a0")).name="Speaker"
		var line:=UI.label(box,bubble.text,Rect2(20,35,568,50),22,Color("fff0cb"),HORIZONTAL_ALIGNMENT_LEFT,true)
		line.name="Line";L.fit(line,22,18)
	if not crew_id.is_empty():
		var entry:Dictionary=game.campaign.crew_entry(crew_id)
		var crew:=Kit.panel(card,Rect2(28,816,608,80),Color("123e3c"),Color("38dbc3"),2,18)
		crew.name="CrewCard"
		var portrait:=Portrait.new();crew.add_child(portrait);portrait.position=Vector2(10,4);portrait.size=Vector2(90,72);portrait.setup(crew_id,true)
		UI.label(crew,"NEW CREW MEMBER",Rect2(118,10,462,24),16,Color("38dbc3"))
		UI.label(crew,entry.get("name",crew_id),Rect2(118,36,462,34),27,Color("ffe5a0"))
	var reward_y:=816+extra
	var gold:=Kit.panel(card,Rect2(28,reward_y,296,76),Color("163944"),Color("496263"),1,16)
	Kit.coin(gold,Vector2(38,38),24)
	UI.label(gold,"GOLD EARNED",Rect2(80,8,200,22),15,Color("c9b58c"))
	gold_label=UI.label(gold,"",Rect2(80,30,200,38),31,Color("ffe5a0"));gold_label.name="GoldReward"
	var star_reward:=Kit.panel(card,Rect2(340,reward_y,296,76),Color("163944"),Color("496263"),1,16)
	Kit.icon(star_reward,"star",Vector2(38,38),24)
	UI.label(star_reward,"STARS ADDED",Rect2(80,8,200,22),15,Color("c9b58c"))
	UI.label(star_reward,"+%d"%int(win.get("new_stars",0)),Rect2(80,30,200,38),31,Color("ffe5a0")).name="StarsAdded"
	continue_button=UI.button(card,L.text("ui.continue"),Rect2(28,912+extra,608,80),game._complete_continue,true,32)
	continue_button.name="Continue"
	action_y=1008+extra
	double_button=UI.button(card,"Watch Ad · 2× Coins",Rect2(28,action_y,296,56),func():game.commerce.show_rewarded("double"),false,20)
	double_button.name="Double"
	museum_button=UI.button(card,L.text("museum.view_museum"),Rect2(340,action_y,296,56),func():
		game._show_gallery("paintings")
		game.screen_view.floor_number=int(game.campaign.stage_for_level(game.campaign.level_number(art_id)).number)
		game.screen_view.refresh(),false,20)
	museum_button.name="ViewMuseum"
	museum_button.visible=not(game.campaign.is_finale(art_id) and win.get("first",false))
	confetti=Confetti.new();confetti.name="Confetti";card.add_child(confetti)
	confetti.position=Vector2.ZERO;confetti.size=Vector2(664,700);confetti.setup(reduced)
	resized.connect(_layout);_layout();refresh(win)
	_sample(Confetti.DURATION if reduced else 0.0)
	set_process(not reduced)

func _layout()->void:
	if is_instance_valid(card):card.position=Vector2(28,maxf(24,(size.y-card.size.y)*.5))

func refresh(result:Dictionary={})->void:
	if not result.is_empty():win=result
	gold_label.text="+%s"%L.number(int(win.get("gold",0)))
	double_button.visible=not win.get("double_used",false) and int(win.get("gold",0))>0 and game.store.state.completed.size()>=int(game.store.rules.ads_from_heist)
	var visible_actions:Array[Button]=[]
	if double_button.visible:visible_actions.append(double_button)
	if museum_button.visible:visible_actions.append(museum_button)
	card.size.y=full_card_height-(72 if visible_actions.is_empty() else 0)
	_layout()
	for i in visible_actions.size():
		visible_actions[i].position=Vector2(28+i*312,action_y)
		visible_actions[i].size=Vector2(608 if visible_actions.size()==1 else 296,56)
	var focus:Array[Button]=[continue_button];focus.append_array(visible_actions)
	for i in focus.size():
		focus[i].focus_next=focus[i].get_path_to(focus[(i+1)%focus.size()])
		focus[i].focus_previous=focus[i].get_path_to(focus[(i+focus.size()-1)%focus.size()])

func _process(delta:float)->void:
	if game.app_suspended or not game.modal_kind.is_empty():return
	advance_celebration(delta)

func advance_celebration(delta:float)->void:
	if reduced:return
	_sample(minf(Confetti.DURATION,celebration_age+maxf(0,delta)))
	if celebration_age>=Confetti.DURATION:set_process(false)

func _sample(age:float)->void:
	celebration_age=age
	for i in stars.size():
		var p:=clampf((age-.10-i*.14)/.28,0,1)
		var scale_value:=1.0 if reduced else _pop(p)
		stars[i].scale=Vector2.ONE*scale_value
	var progress:=1.0 if reduced else clampf(age/.5,0,1)
	frame.scale=Vector2.ONE*lerpf(.82,1.0,_ease_out(progress))
	frame.modulate.a=lerpf(.25,1,progress)
	var settle:=1.0 if reduced else clampf((age-.12)/.55,0,1)
	portraits.position=portrait_origin+Vector2(0,18*(1-_ease_out(settle)))
	portraits.modulate.a=lerpf(.3,1,settle)
	confetti.sample(age)

func _ease_out(value:float)->float:return 1-pow(1-value,3)
func _pop(value:float)->float:
	var shifted:=value-1.0
	return 1+2.70158*pow(shifted,3)+1.70158*pow(shifted,2)
