extends RefCounted
## Shared enamel controls for S5 and Painting Detail.
const Kit=preload("res://scripts/ui/ui_kit.gd")
const FONT=preload("res://assets/fonts/Lora-700.ttf")

static func style(button:Button,primary:=false)->void:
	button.add_theme_font_override("font",FONT)
	button.add_theme_constant_override("outline_size",0)
	for key in ["font_color","font_hover_color","font_pressed_color","font_focus_color"]:
		button.add_theme_color_override(key,Color("fff0cb"))
	for state in ["normal","hover","pressed","focus","disabled"]:
		var fill:=Color("087f72") if primary else Color("163944")
		if state=="hover":fill=fill.lightened(.12)
		if state=="pressed":fill=fill.darkened(.15)
		if state=="disabled":fill=Color("20363d")
		var skin:=Kit.panel_style(fill,Color("edc77e") if state!="disabled" else Color("697771"),3,16)
		skin.shadow_size=4
		skin.shadow_offset=Vector2(0,4 if state!="pressed" else 1)
		if state=="focus":
			skin.bg_color=Color.TRANSPARENT
			skin.border_color=Color("38dbc3")
			skin.shadow_size=0
		button.add_theme_stylebox_override(state,skin)
	if not button.has_node("EnamelHighlight"):
		var shine:=ColorRect.new()
		shine.name="EnamelHighlight"
		shine.mouse_filter=Control.MOUSE_FILTER_IGNORE
		shine.color=Color(1,.94,.8,.20)
		button.add_child(shine)
		shine.set_anchors_and_offsets_preset(Control.PRESET_TOP_WIDE)
		shine.offset_left=17;shine.offset_right=-17;shine.offset_top=5;shine.offset_bottom=7

static func label(parent:Node,text:String,rect:Rect2,font_size:=22,color:=Color("fff0cb"),align:=HORIZONTAL_ALIGNMENT_LEFT,wrap:=false)->Label:
	var view:=Kit.label(parent,text,rect,font_size,color,0,align,wrap)
	view.add_theme_font_override("font",FONT)
	return view

static func button(parent:Node,text:String,rect:Rect2,action:Callable,primary:=false,font_size:=24)->Button:
	var view:=Kit.button(parent,text,rect,action,"secondary",font_size)
	style(view,primary)
	return view

static func modal(overlay:Control,title:String,height:float,on_close:Callable)->Panel:
	var shade:=ColorRect.new()
	shade.color=Color(.015,.03,.05,.80)
	overlay.add_child(shade)
	shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var card:=Kit.panel(overlay,Rect2(40,maxf(32,(overlay.size.y-height)*.5),640,height),Color("102a35"),Color("edc77e"),3,28)
	card.name="Card";card.mouse_filter=Control.MOUSE_FILTER_STOP
	var title_label:=label(card,title,Rect2(28,24,490,52),34,Color("ffe5a0"))
	title_label.name="Title"
	preload("res://scripts/services/localization.gd").fit(title_label,34,24)
	var close:=button(card,"",Rect2(546,20,66,64),on_close)
	close.name="Close"
	preload("res://scripts/ui/museum_icon.gd").attach(close,"close","Close",false,true)
	var rule:=ColorRect.new();rule.color=Color("766341");rule.mouse_filter=Control.MOUSE_FILTER_IGNORE
	card.add_child(rule);rule.position=Vector2(28,96);rule.size=Vector2(584,1)
	return card
