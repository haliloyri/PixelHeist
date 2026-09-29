extends RefCounted
## Shared r13 look (design section 15): copper/brass round buttons, wood-and-metal
## panels, gold lettering, the museum-hall background. Every pop-up uses card():
## ribbon title, central content, at most two buttons, close X.
const INK := Color("2a1a10")
const CREAM := Color("fff1d6")
const GOLD := Color("f4c98b")
const COPPER := Color("c08a4a")
const WOOD := Color("3a2616")
const WOOD_DARK := Color("24160c")
const MUTED := Color("d8c3a0")
const GREEN := Color("7bc043")
const ORANGE := Color("f2a93b")
const RED := Color("e0533d")
const PURPLE := Color("9b5de5")
const BG := "res://assets/lobby/lobby_bg.png"
const Loc = preload("res://scripts/services/localization.gd")

static var _fonts: Dictionary = {}

static func font(weight: int = 800) -> Font:
	if not _fonts.has(weight):
		var f := SystemFont.new()
		f.font_names = PackedStringArray(["Arial Rounded MT Bold", "Avenir Next", "Helvetica Neue", "Roboto", "sans-serif"])
		f.font_weight = weight
		_fonts[weight] = f
	return _fonts[weight]

static func label(parent: Node, text: String, rect: Rect2, size: int = 26, color: Color = CREAM, outline: int = 6, align := HORIZONTAL_ALIGNMENT_CENTER, wrap := false) -> Label:
	var l := Label.new()
	if wrap:
		l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		# Wrapped labels measure their minimum height at their minimum width; fixing the
		# width first keeps text inside its box instead of one word per line.
		l.custom_minimum_size = Vector2(rect.size.x, 0)
		l.clip_text = false
	l.text = text
	l.horizontal_alignment = align
	l.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	l.mouse_filter = Control.MOUSE_FILTER_IGNORE
	l.add_theme_font_override("font", font())
	l.add_theme_font_size_override("font_size", size)
	l.add_theme_color_override("font_color", color)
	if outline > 0:
		l.add_theme_constant_override("outline_size", outline)
		l.add_theme_color_override("font_outline_color", INK)
	parent.add_child(l)
	l.position = rect.position
	l.size = Vector2(rect.size.x, 0)
	l.size = rect.size
	return l

static func panel_style(fill: Color, border: Color, width: int = 5, radius: int = 26) -> StyleBoxFlat:
	var s := StyleBoxFlat.new()
	s.bg_color = fill
	s.border_color = border
	s.set_border_width_all(width)
	s.set_corner_radius_all(radius)
	s.shadow_color = Color(0, 0, 0, .45)
	s.shadow_size = 10
	s.shadow_offset = Vector2(0, 6)
	return s

static func panel(parent: Node, rect: Rect2, fill: Color = WOOD, border: Color = COPPER, width: int = 5, radius: int = 26) -> Panel:
	var p := Panel.new()
	p.mouse_filter = Control.MOUSE_FILTER_IGNORE
	p.add_theme_stylebox_override("panel", panel_style(fill, border, width, radius))
	parent.add_child(p)
	p.position = rect.position
	p.size = rect.size
	return p

## Chunky copper button. kind: "primary" (orange), "green", "secondary" (wood), "disabled".
static func button(parent: Node, text: String, rect: Rect2, action: Callable, kind: String = "primary", size: int = 28) -> Button:
	var b := Button.new()
	b.text = text
	b.focus_mode = Control.FOCUS_ALL
	b.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	b.add_theme_font_override("font", font())
	b.add_theme_font_size_override("font_size", size)
	var fill: Color = {"primary": ORANGE, "green": GREEN, "secondary": Color("5a3b22"), "disabled": Color("6b6158")}.get(kind, ORANGE)
	var text_color: Color = INK if kind in ["primary", "green"] else CREAM
	for state in ["normal", "hover", "pressed", "focus", "disabled"]:
		var f: Color = fill
		if state == "hover": f = fill.lightened(.08)
		if state == "pressed": f = fill.darkened(.12)
		if state == "disabled": f = Color("6b6158")
		var s := panel_style(f, Color("7a4d12") if kind != "secondary" else COPPER, 4, int(rect.size.y * .38))
		s.shadow_size = 4
		s.shadow_offset = Vector2(0, 4 if state != "pressed" else 1)
		if state == "focus":
			s.bg_color = Color(0, 0, 0, 0)
			s.border_color = Color.WHITE
			s.shadow_size = 0
		b.add_theme_stylebox_override(state, s)
	for key in ["font_color", "font_hover_color", "font_pressed_color", "font_focus_color"]:
		b.add_theme_color_override(key, text_color)
	b.add_theme_color_override("font_disabled_color", Color("c9bfb2"))
	b.add_theme_constant_override("outline_size", 0 if kind in ["primary", "green"] else 5)
	b.add_theme_color_override("font_outline_color", INK)
	if kind == "disabled": b.disabled = true
	parent.add_child(b)
	b.position = rect.position
	b.size = rect.size
	b.pressed.connect(action)
	return b

## Gold ribbon banner with dark lettering.
static func ribbon(parent: Node, text: String, center: Vector2, width: float = 420.0, size: int = 34) -> Control:
	var holder := Control.new()
	holder.mouse_filter = Control.MOUSE_FILTER_IGNORE
	parent.add_child(holder)
	holder.position = center - Vector2(width * .5, 38)
	holder.size = Vector2(width, 76)
	for side in [-1, 1]:
		var tail := Polygon2D.new()
		var x: float = 0.0 if side < 0 else width
		tail.polygon = PackedVector2Array([Vector2(x - side * 30, 18), Vector2(x + side * 34, 18), Vector2(x + side * 18, 44), Vector2(x + side * 34, 70), Vector2(x - side * 30, 70)])
		tail.color = Color("b9852f")
		holder.add_child(tail)
	var band := Panel.new()
	band.mouse_filter = Control.MOUSE_FILTER_IGNORE
	band.add_theme_stylebox_override("panel", panel_style(Color("e6b64c"), Color("7a4d12"), 4, 16))
	holder.add_child(band)
	band.size = Vector2(width, 64)
	band.position = Vector2(0, 6)
	var l := label(holder, text, Rect2(0, 6, width, 64), size, INK, 0)
	l.add_theme_color_override("font_color", INK)
	return holder

## Round close button (X).
static func close_button(parent: Node, center: Vector2, action: Callable) -> Button:
	var b := button(parent, "X", Rect2(center - Vector2(32, 32), Vector2(64, 64)), action, "secondary", 28)
	b.name = "Close"
	return b

## Standard pop-up card: dark shade, wooden card with copper rim, ribbon title.
## Returns the card; content is placed in card-local coordinates (card width 600).
static func card(overlay: Control, title: String, height: float = 620.0, on_close = null) -> Panel:
	var shade := ColorRect.new()
	shade.color = Color(0.02, 0.02, 0.05, 0.72)
	shade.mouse_filter = Control.MOUSE_FILTER_STOP
	overlay.add_child(shade)
	shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var viewport_h: float = overlay.size.y if overlay.size.y > 0 else 1280.0
	var rect := Rect2(60, maxf(120.0, (viewport_h - height) * .5), 600, height)
	var c := panel(overlay, rect, WOOD, COPPER, 6, 30)
	c.name = "Card"
	var inner := panel(c, Rect2(14, 14, rect.size.x - 28, rect.size.y - 28), WOOD_DARK, Color("8a6038"), 2, 22)
	inner.name = "Inner"
	ribbon(c, title, Vector2(rect.size.x * .5, 0), 440, 32)
	if on_close is Callable: close_button(c, Vector2(rect.size.x - 12, 12), on_close)
	return c

static func texture(path: String) -> Texture2D:
	return load(path) if ResourceLoader.exists(path) else null

static func image(parent: Node, path: String, rect: Rect2) -> TextureRect:
	var t := TextureRect.new()
	t.texture = texture(path)
	t.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	t.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	t.mouse_filter = Control.MOUSE_FILTER_IGNORE
	parent.add_child(t)
	t.position = rect.position
	t.size = rect.size
	return t

static func background(parent: Control, dim: float = 0.0) -> void:
	var t := TextureRect.new()
	t.name = "Background"
	t.texture = texture(BG)
	t.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	t.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	t.mouse_filter = Control.MOUSE_FILTER_IGNORE
	parent.add_child(t)
	t.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	if dim > 0:
		var shade := ColorRect.new()
		shade.color = Color(0, 0, 0, dim)
		shade.mouse_filter = Control.MOUSE_FILTER_IGNORE
		parent.add_child(shade)
		shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

## Gold coin icon drawn in code (keeps icons crisp at any size).
static func coin(parent: Node, center: Vector2, radius: float = 18.0) -> Control:
	var c := IconDraw.new()
	c.kind = "coin"
	parent.add_child(c)
	c.position = center - Vector2(radius, radius)
	c.size = Vector2(radius, radius) * 2
	return c

static func icon(parent: Node, kind: String, center: Vector2, radius: float = 18.0, tint: Color = Color.WHITE) -> Control:
	var c := IconDraw.new()
	c.kind = kind
	c.tint = tint
	parent.add_child(c)
	c.position = center - Vector2(radius, radius)
	c.size = Vector2(radius, radius) * 2
	return c

class IconDraw extends Control:
	var kind := "coin"
	var tint := Color.WHITE
	var filled := true
	func _ready() -> void:
		mouse_filter = Control.MOUSE_FILTER_IGNORE
	func _draw() -> void:
		var r: float = size.x * .5
		var c := size * .5
		match kind:
			"coin":
				draw_circle(c + Vector2(0, 2), r, Color("8a5a12"))
				draw_circle(c, r, Color("f6c945"))
				draw_circle(c, r * .72, Color("ffdd6e"))
				draw_arc(c, r * .72, 0, TAU, 32, Color("c98e1f"), 2, true)
			"star":
				var pts := PackedVector2Array()
				for i in 10:
					var a := -PI / 2 + i * PI / 5
					var rr: float = r if i % 2 == 0 else r * .45
					pts.append(c + Vector2(cos(a), sin(a)) * rr)
				draw_colored_polygon(pts, Color("f6c945") if filled else Color(0.2, 0.15, 0.1, .7))
				pts.append(pts[0])
				draw_polyline(pts, Color("7a4d12"), 2.5, true)
			"heart":
				var h := PackedVector2Array()
				for i in 40:
					var t := TAU * i / 40.0
					h.append(c + Vector2(16 * pow(sin(t), 3), -(13 * cos(t) - 5 * cos(2 * t) - 2 * cos(3 * t) - cos(4 * t))) * (r / 17.0))
				draw_colored_polygon(h, Color("e0533d") if filled else Color("5a4a44"))
			"lock":
				draw_rect(Rect2(c + Vector2(-r * .6, -r * .1), Vector2(r * 1.2, r * .95)), Color("c08a4a"))
				draw_arc(c + Vector2(0, -r * .1), r * .42, PI, TAU, 16, Color("c08a4a"), r * .18, true)
			"frame":
				draw_rect(Rect2(c - Vector2(r, r * .8), Vector2(r * 2, r * 1.6)), Color("e6b64c"))
				draw_rect(Rect2(c - Vector2(r * .72, r * .54), Vector2(r * 1.44, r * 1.08)), Color("3b5f8a"))
				draw_circle(c + Vector2(r * .25, -r * .15), r * .16, Color("f6c945"))
				draw_colored_polygon(PackedVector2Array([c + Vector2(-r * .72, r * .54), c + Vector2(-r * .15, -r * .05), c + Vector2(r * .3, r * .54)]), Color("5f9e4a"))
			"bug":
				draw_circle(c + Vector2(0, r * .15), r * .82, Color("20242b"))
				draw_circle(c + Vector2(0, r * .2), r * .7, tint)
				draw_line(c + Vector2(0, -r * .45), c + Vector2(0, r * .9), Color("20242b"), 3)
				for side in [-1, 1]:
					draw_circle(c + Vector2(side * r * .32, -r * .55), r * .2, Color("20242b"))
					draw_circle(c + Vector2(side * r * .32, -r * .58), r * .12, Color("7cf7ff"))
					draw_circle(c + Vector2(side * r * .35, r * .3), r * .12, Color("20242b"))
			"booster":
				draw_circle(c, r, Color("5a3b22"))
				draw_circle(c, r * .82, tint)

## Bottom tab bar shared by Shop and Gallery (same art as the Safehouse).
static func nav(parent: Control, game, active: String) -> void:
	var bar := TextureRect.new()
	bar.name = "NavBar"
	bar.texture = texture("res://assets/lobby/nav_bar.png")
	bar.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	bar.stretch_mode = TextureRect.STRETCH_SCALE
	bar.mouse_filter = Control.MOUSE_FILTER_IGNORE
	parent.add_child(bar)
	bar.anchor_top = 1.0
	bar.anchor_bottom = 1.0
	bar.anchor_right = 1.0
	bar.offset_top = -112.5
	bar.offset_bottom = 0
	var k := 720.0 / 768.0
	var cover := panel(bar, Rect2(522 * k, 6 * k, 90 * k, 72 * k), Color("27479a"), Color("1a2f66"), 2, 14)
	icon(cover, "frame", cover.size * .5, 26)
	var tabs := [["shop", 118, 170, "lobby.shop"], ["safehouse", 292, 186, "lobby.safehouse"], ["gallery", 482, 170, "lobby.gallery"]]
	for tab in tabs:
		var b := Button.new()
		b.name = "Nav" + str(tab[0]).capitalize()
		b.flat = true
		for state in ["normal", "hover", "pressed", "focus", "disabled"]:
			b.add_theme_stylebox_override(state, StyleBoxEmpty.new())
		bar.add_child(b)
		b.position = Vector2(float(tab[1]) * k, 0)
		b.size = Vector2(float(tab[2]) * k, 112.5)
		match tab[0]:
			"shop": b.pressed.connect(func(): game._show_shop())
			"safehouse": b.pressed.connect(func(): game._show_lobby())
			"gallery": b.pressed.connect(func(): game._show_gallery("paintings"))
		var l := label(bar, Loc.upper(Loc.text(tab[3])), Rect2(float(tab[1]) * k, 73, float(tab[2]) * k, 38), 24, GOLD if tab[0] == active else CREAM, 7)
