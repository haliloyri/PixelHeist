extends RefCounted
const COLORS = {"ink":Color("17213f"),"paper":Color("fff4df"),"gold":Color("ffc857"),"cobalt":Color("4775ff")}

## Heist v2 ("Bit'lerin gece soygunu") tokens: single source of truth for the
## redesigned heist screen. Read once from data/design_tokens.json; the
## legacy night palette above (ink/cobalt/...) stays untouched for other screens.
static var HEIST_V2: Dictionary = _load_heist_v2()
static func _load_heist_v2() -> Dictionary:
	var raw: String = FileAccess.get_file_as_string("res://data/design_tokens.json")
	var parsed: Dictionary = JSON.parse_string(raw) if not raw.is_empty() else {}
	return parsed.get("heist_v2", {})
static func hv2_color(group: String, key: String, fallback: String) -> Color:
	return Color(HEIST_V2.get(group, {}).get(key, fallback))

static func panel(fill: Color,edge: Color,radius: int=22,width: int=2) -> StyleBoxFlat:
	var style:=StyleBoxFlat.new();style.bg_color=fill;style.border_color=edge
	style.set_corner_radius_all(radius);style.set_border_width_all(width)
	style.border_width_bottom=width+4;style.shadow_color=Color(0.025,.035,.10,.38);style.shadow_size=7;style.shadow_offset=Vector2(0,5)
	style.content_margin_left=16;style.content_margin_right=16
	return style

static func button(button: Button,primary: bool,color: Color) -> void:
	button.add_theme_stylebox_override("normal",panel(color if primary else Color("253759"),color if primary else Color("4775ff")))
	button.add_theme_stylebox_override("hover",panel(color.lightened(.12) if primary else Color("314978"),Color("3edde6")))
	button.add_theme_stylebox_override("pressed",panel(color.darkened(.14) if primary else Color("17213f"),color,22,1))
	button.add_theme_stylebox_override("disabled",panel(Color("202b43"),Color("445274")))
	var focus:=StyleBoxFlat.new();focus.bg_color=Color.TRANSPARENT;focus.border_color=Color("3edde6");focus.set_border_width_all(4);focus.set_corner_radius_all(22)
	button.add_theme_stylebox_override("focus",focus)

static func modal(parent: Control,title: String,eyebrow: String,game) -> void:
	var shade:=ColorRect.new();parent.add_child(shade);shade.color=Color(.018,.025,.065,.92);shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var card:=Panel.new();parent.add_child(card);card.position=Vector2(42,253);card.size=Vector2(636,713);card.add_theme_stylebox_override("panel",panel(Color("253759"),Color("4775ff"),36,3))
	# Original raised inventory seal; shared by settings, briefings and decisions.
	for i in 3:
		var seal:=Panel.new();card.add_child(seal);seal.position=Vector2(540-i*19,-24+i*10);seal.size=Vector2(36,36);seal.rotation=.14*(i-1);seal.add_theme_stylebox_override("panel",panel([Color("ffc857"),Color("ff6b83"),Color("3edde6")][i],Color("17213f"),8,2));seal.mouse_filter=Control.MOUSE_FILTER_IGNORE
	game._label(parent,eyebrow,Rect2(78,287,520,30),16,Color("3edde6"))
	game._label(parent,title,Rect2(78,332,564,104),38)
