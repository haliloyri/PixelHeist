extends Control
## Illustrated S1 navigation, with native labels and a quiet selected state.
const Art=preload("res://scripts/ui/home_art.gd")
const UI=preload("res://scripts/ui/museum_controls.gd")
const Kit=preload("res://scripts/ui/ui_kit.gd")
const L=preload("res://scripts/services/localization.gd")
const HEIGHT=146.0
var selected:=1:
	set(value):
		selected=value
		queue_redraw()

func _ready()->void:
	mouse_filter=Control.MOUSE_FILTER_IGNORE
	for i in 3:
		var center:float=[130,360,590][i]
		Art.attach(self,["shop","home","museum"][i],Rect2(center-48,8,96,90))
		UI.label(self,L.text(["lobby.shop","lobby.home","lobby.museum"][i]),Rect2(center-100,100,200,30),22,Color("fff0cb"),HORIZONTAL_ALIGNMENT_CENTER)

func _draw()->void:
	var background:=Kit.panel_style(Color("102a35"),Color("48606a"),1,22)
	background.shadow_size=0
	draw_style_box(background,Rect2(Vector2.ZERO,size))
	var center:float=[130,360,590][clampi(selected,0,2)]
	var active:=Kit.panel_style(Color("184750"),Color("28636a"),1,18)
	active.shadow_size=0
	draw_style_box(active,Rect2(center-100,5,200,134))
	draw_line(Vector2(center-42,136),Vector2(center+42,136),Color("38dbc3"),3,true)
	for x in [245,475]:draw_line(Vector2(x,26),Vector2(x,119),Color("35525a"),1,true)

static func add_hit(parent:Control,rect:Rect2,title:String,action:Callable)->Button:
	var button:=Button.new()
	button.position=rect.position;button.size=rect.size
	button.tooltip_text=title
	button.set_meta("accessible_label",title)
	button.mouse_default_cursor_shape=Control.CURSOR_POINTING_HAND
	for state in ["normal","hover","pressed","disabled"]:
		var style:=StyleBoxFlat.new()
		style.bg_color=Color(0.3,1.0,.85,.07 if state=="hover" else .13 if state=="pressed" else 0)
		style.set_corner_radius_all(18)
		button.add_theme_stylebox_override(state,style)
	var focus:=StyleBoxFlat.new()
	focus.bg_color=Color.TRANSPARENT;focus.border_color=Color("38dbc3")
	focus.set_border_width_all(2);focus.set_corner_radius_all(18)
	button.add_theme_stylebox_override("focus",focus)
	parent.add_child(button)
	button.pressed.connect(action)
	return button
