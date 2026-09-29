extends RefCounted
## Approved v4 visual resources. Atlas regions are explicit, not an assumed grid.
const ATLAS = preload("res://assets/heist_v4/atlas.png")
const FONT = preload("res://assets/fonts/Lora-700.ttf")
const AntSkin = preload("res://scripts/ui/ant_skin.gd")
const NAVY = Color("151d35")
const GOLD = Color("b89350")
const IVORY = Color("f2e5ca")
const ICE = Color("80dce8")
static var cache: Dictionary = {}

static func region(rect: Rect2) -> AtlasTexture:
	var texture := AtlasTexture.new()
	texture.atlas = ATLAS
	texture.region = rect
	texture.filter_clip = true
	return texture

static func icon(kind: int) -> Texture2D:
	var rects := [Rect2(337,945,118,113), Rect2(467,953,146,94), Rect2(620,940,145,127)]
	return region(rects[clampi(kind,0,2)])

static func body(tint: Color) -> Texture2D:
	var key := tint.to_html(false)
	if cache.has(key): return cache[key]
	# Recolor only the cyan enamel of this single shared master. Brass/hatch remain intact.
	var image := ATLAS.get_image()
	if image.is_compressed(): image.decompress()
	image = image.get_region(Rect2i(8,225,148,113))
	image.convert(Image.FORMAT_RGBA8)
	for y in image.get_height():
		for x in image.get_width():
			var c := image.get_pixel(x,y)
			if c.a < .03: continue
			if c.h > .40 and c.h < .59 and c.s > .10:
				var k := clampf(c.get_luminance() / .54,.45,1.35)
				var painted := tint * minf(k,1.0)
				if k > 1.0: painted = tint.lerp(Color.WHITE,(k-1.0)*.5)
				painted.a = c.a
				image.set_pixel(x,y,painted)
	var texture := ImageTexture.create_from_image(image)
	cache[key] = texture
	return texture

static func panel(canvas: CanvasItem, rect: Rect2, fill: Color = NAVY, edge: Color = GOLD, radius: int = 12, width: int = 2) -> void:
	var style := StyleBoxFlat.new()
	style.bg_color = fill
	style.border_color = edge
	style.set_border_width_all(width)
	style.set_corner_radius_all(radius)
	canvas.draw_style_box(style,rect)

static func numeral_font() -> Font:
	return FONT

static func number(canvas: CanvasItem, point: Vector2, value: String, font_size: int = 28) -> void:
	var font := numeral_font()
	var at := point + Vector2(-font.get_string_size(value,HORIZONTAL_ALIGNMENT_LEFT,-1,font_size).x*.5,(font.get_ascent(font_size)-font.get_descent(font_size))*.5)
	canvas.draw_string_outline(font,at,value,HORIZONTAL_ALIGNMENT_LEFT,-1,font_size,4,Color("182b30"))
	canvas.draw_string(font,at,value,HORIZONTAL_ALIGNMENT_LEFT,-1,font_size,IVORY)

static func carrier(canvas: CanvasItem, center: Vector2, tint: Color, value: String, width: float, open: float, phase: float = 0.0) -> void:
	var extent := Vector2(width,width*113.0/148.0)
	if open > .01:
		for side in [-1,1]:
			var hub := center + Vector2(side*width*(.30+.13*open),-extent.y*(.20+.40*open))
			canvas.draw_line(center+Vector2(side*width*.39,-extent.y*.12),hub,Color("a87346"),4,true)
			canvas.draw_circle(hub,4.5,Color("332317"))
			canvas.draw_circle(hub,2.8,GOLD)
			var blade := Vector2(cos(phase)*width*.095, sin(phase)*width*.02)
			canvas.draw_line(hub-blade,hub+blade,GOLD,3,true)
	canvas.draw_texture_rect(body(tint),Rect2(center-extent*.5,extent),false)
	if value.is_empty():
		var badge := Vector2(width*.21,width*.37)
		canvas.draw_texture_rect(AntSkin.texture(tint),Rect2(center-badge*.5,badge),false)
	if not value.is_empty(): number(canvas,center+Vector2(0,-extent.y*.01),value,int(width*.34))

static func halo(canvas: CanvasItem, rect: Rect2, focused: bool = false) -> void:
	for i in range(4,0,-1):
		panel(canvas,rect.grow(i*1.5),Color.TRANSPARENT,Color(ICE,.06),10+i,2)
	panel(canvas,rect,Color.TRANSPARENT,Color(ICE,.9 if focused else .68),10,2)
