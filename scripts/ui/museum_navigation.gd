extends Control
## Reference-home navigation treatment: brass edging, navy enamel and teal light.
const Icon=preload("res://scripts/ui/museum_icon.gd")
const FONT=preload("res://assets/fonts/Lora-700.ttf")
const GOLD=Color("c6a16a")
const TEAL=Color("38dbc3")
var selected:=0

func _ready()->void:
	mouse_filter=Control.MOUSE_FILTER_IGNORE

func _draw()->void:
	var edge:=StyleBoxFlat.new()
	edge.bg_color=Color("102a35")
	edge.border_color=GOLD
	edge.set_border_width_all(2)
	edge.corner_radius_top_left=20
	edge.corner_radius_top_right=20
	edge.corner_radius_bottom_left=20
	edge.corner_radius_bottom_right=20
	draw_style_box(edge,Rect2(Vector2.ZERO,size))
	for y in range(4,int(size.y)):
		var shine:=1.0-float(y)/size.y
		draw_line(Vector2(2,y),Vector2(size.x-2,y),Color(.22,.42,.48,shine*.32))
	draw_line(Vector2(20,4),Vector2(size.x-20,4),Color("ffe5a0"),1,true)
	var cell:=size.x/3.0
	for x in [cell,cell*2]:draw_line(Vector2(x,size.y*.22),Vector2(x,size.y*.78),Color("75664d"),1)
	var center:=cell*(selected+.5)
	for i in range(20,0,-1):
		draw_circle(Vector2(center,size.y*.53),float(i)*3.2,Color(.06,.8,.66,.007))
	var underline:=size.y-7
	draw_line(Vector2(center-43,underline),Vector2(center+43,underline),TEAL,4,true)
	draw_colored_polygon(PackedVector2Array([Vector2(center-7,3),Vector2(center+7,3),Vector2(center,9)]),TEAL)

static func add_button(parent:Control,rect:Rect2,kind:String,title:String,active:bool,action:Callable)->Button:
	var button:=Button.new()
	button.position=rect.position
	button.size=rect.size
	button.tooltip_text=title
	button.set_meta("accessible_label",title)
	button.mouse_default_cursor_shape=Control.CURSOR_POINTING_HAND
	for state in ["normal","pressed","hover"]:
		var style:=StyleBoxFlat.new()
		style.bg_color=Color(0.1,.7,.6,.08 if state=="hover" else .13 if state=="pressed" else 0)
		style.set_corner_radius_all(14)
		button.add_theme_stylebox_override(state,style)
	var focus:=StyleBoxFlat.new()
	focus.bg_color=Color.TRANSPARENT
	focus.border_color=TEAL
	focus.set_border_width_all(2)
	focus.set_corner_radius_all(14)
	button.add_theme_stylebox_override("focus",focus)
	parent.add_child(button)
	button.pressed.connect(action)
	var extent:=minf(56,rect.size.y-46)
	var icon:=Icon.new()
	icon.kind=kind
	icon.selected=active
	icon.relief=true
	icon.illustrated=true
	icon.name="Icon"
	icon.mouse_filter=Control.MOUSE_FILTER_IGNORE
	icon.position=Vector2((rect.size.x-extent)*.5,8)
	icon.size=Vector2.ONE*extent
	button.add_child(icon)
	var label:=Label.new()
	label.text=title.to_upper()
	label.name="Caption"
	label.position=Vector2(0,extent+8)
	label.size=Vector2(rect.size.x,27)
	label.horizontal_alignment=HORIZONTAL_ALIGNMENT_CENTER
	label.add_theme_font_override("font",FONT)
	label.add_theme_font_size_override("font_size",20 if rect.size.y<110 else 23)
	label.add_theme_color_override("font_color",Color("f6dba3"))
	label.add_theme_color_override("font_outline_color",Color("040d11"))
	label.add_theme_constant_override("outline_size",2)
	label.mouse_filter=Control.MOUSE_FILTER_IGNORE
	button.add_child(label)
	return button
