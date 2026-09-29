extends RefCounted
const UI=preload("res://scripts/ui/museum_controls.gd")
const Kit=preload("res://scripts/ui/ui_kit.gd")
const Switch=preload("res://scripts/ui/settings_switch.gd")
const L=preload("res://scripts/services/localization.gd")
const ROWS=[
	["sound","Sound effects","Ants, pickups and game sounds."],
	["music","Music","Background music during heists."],
	["vibration","Vibration","Light feedback when pixels are collected."],
	["reduced_motion","Reduced motion","Less movement and gentler transitions."]]
static func build(game,overlay:Control,in_heist:bool)->Panel:
	var card:=UI.modal(overlay,"Paused" if in_heist else "Settings",894 if in_heist else 682,game._close_modal)
	UI.label(card,"Make yourself comfortable.",Rect2(32,110,576,34),20,Color("c9b58c"))
	for i in ROWS.size():
		var row:Array=ROWS[i]
		var y:=158+i*96
		var panel:=Kit.panel(card,Rect2(28,y,584,84),Color("163944"),Color("496263"),1,16)
		UI.label(panel,row[1],Rect2(18,10,400,30),24)
		UI.label(panel,row[2],Rect2(18,46,422,25),18,Color("c9b58c"))
		var toggle:=Switch.new()
		toggle.name="Toggle_"+str(row[0])
		card.add_child(toggle);toggle.position=Vector2(478,y+8);toggle.size=Vector2(116,68)
		toggle.pressed.connect(game._toggle_setting.bind(row[0]))
	refresh(card,game.store.state.settings)
	if in_heist:
		UI.button(card,"Resume",Rect2(28,564,584,76),game._close_modal,true,28).name="Resume"
		UI.button(card,"Safehouse  ·  -1 energy",Rect2(28,660,584,64),game._quit_heist,false,22).name="QuitHeist"
		UI.label(card,"MORE BOOSTERS",Rect2(32,746,576,28),18,Color("c9b58c"))
		for i in 2:
			var id:String=["scout_fly","master_key"][i]
			UI.button(card,L.text(game.BOOSTER_NAMES[id])+"  ·  %d"%game.store.booster_count(id),Rect2(28+i*302,790,282,66),func():game._close_modal();game._use_booster(id),false,21).name="Booster_"+id
	else:
		UI.button(card,"Done",Rect2(28,562,584,70),game._close_modal,true,27).name="Done"
		UI.label(card,L.text("settings.version",{"version":str(ProjectSettings.get_setting("application/config/version","1.0"))}),Rect2(32,645,576,24),16,Color("c9b58c"),HORIZONTAL_ALIGNMENT_CENTER)
	return card
static func refresh(card:Panel,settings:Dictionary)->void:
	for row in ROWS:
		var toggle:Button=card.get_node("Toggle_"+row[0])
		toggle.set_pressed_no_signal(bool(settings[row[0]]))
		toggle.tooltip_text=row[1]+": "+("On" if settings[row[0]] else "Off")
		toggle.set_meta("accessible_label",toggle.tooltip_text)
		toggle.queue_redraw()
