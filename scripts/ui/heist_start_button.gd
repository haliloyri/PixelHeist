extends Button
## Native satin-enamel CTA: live caption, distinct disabled state, no baked text.
const Kit=preload("res://scripts/ui/ui_kit.gd")
const FONT=preload("res://assets/fonts/Lora-700.ttf")
var caption:Label
var available:=true

func _ready()->void:
	mouse_default_cursor_shape=Control.CURSOR_POINTING_HAND
	for state in ["normal","hover","pressed","disabled","focus"]:
		var fill:=Color("138f85")
		if state=="hover":fill=Color("1aa398")
		if state=="pressed":fill=Color("10766e")
		if state=="disabled":fill=Color("243c45")
		var skin:=Kit.panel_style(fill,Color("c6a16a") if state!="disabled" else Color("536c70"),2,28)
		skin.shadow_color=Color("062e32");skin.shadow_size=2
		skin.shadow_offset=Vector2(0,6 if state!="pressed" else 2)
		if state=="focus":
			skin.bg_color=Color.TRANSPARENT;skin.border_color=Color("fff0cb")
			skin.shadow_size=0;skin.shadow_offset=Vector2.ZERO
		add_theme_stylebox_override(state,skin)
	caption=Label.new();caption.name="Caption";caption.mouse_filter=Control.MOUSE_FILTER_IGNORE
	caption.add_theme_font_override("font",FONT);caption.add_theme_font_size_override("font_size",34)
	caption.add_theme_color_override("font_color",Color("fff0cb"))
	caption.horizontal_alignment=HORIZONTAL_ALIGNMENT_CENTER
	caption.vertical_alignment=VERTICAL_ALIGNMENT_CENTER
	add_child(caption);caption.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	caption.offset_left=20;caption.offset_right=-64
	resized.connect(queue_redraw)
	button_down.connect(queue_redraw);button_up.connect(queue_redraw)

func set_available(value:bool,title:String)->void:
	available=value;disabled=not value
	caption.text=title
	caption.offset_right=-64 if value else -20
	caption.modulate=Color.WHITE if value else Color("a8bbbe")
	tooltip_text=title;set_meta("accessible_label",title)
	queue_redraw()

func _draw()->void:
	if size.x<1:return
	# Gentle inset highlight replaces the old bright double gold rim.
	draw_line(Vector2(31,7),Vector2(size.x-31,7),Color(1,.96,.80,.20 if available else .06),1.5,true)
	if available:
		var center:=Vector2(size.x-52,size.y*.5)
		var tri:=PackedVector2Array([center+Vector2(-9,-14),center+Vector2(14,0),center+Vector2(-9,14)])
		draw_colored_polygon(tri,Color("fff0cb"))
