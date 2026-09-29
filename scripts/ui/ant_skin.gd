extends RefCounted
## Top-down robot ant: shell matches the carrier and payload palette.
## Legacy palette helpers remain available to older consumers.
const ANTS := [
	["brown", "824117"], ["red", "ac2526"], ["white", "a6b1c1"], ["black", "29323d"],
	["orange", "e76808"], ["blue", "2869cc"], ["yellow", "e1a515"], ["green", "4d9738"],
	["purple", "723fb4"], ["pink", "dc6096"],
]
static var _bases: Array = []
static var _cache: Dictionary = {}
static var _halos: Dictionary = {}

static func path(index: int) -> String:
	return "res://assets/ants/ant_%02d_%s.png" % [index, ANTS[index][0]]

static func _load_bases() -> void:
	if not _bases.is_empty(): return
	for index in ANTS.size():
		var image: Image
		if ResourceLoader.exists(path(index)):
			image = (load(path(index)) as Texture2D).get_image()
		else:
			# Not yet imported by the editor (fresh checkout / headless run).
			image = Image.load_from_file(ProjectSettings.globalize_path(path(index)))
		if image.is_compressed(): image.decompress()
		image.convert(Image.FORMAT_RGBA8)
		_bases.append(image)

static func nearest(tint: Color) -> int:
	var best := 0
	var best_distance := INF
	for index in ANTS.size():
		var c := Color(ANTS[index][1])
		var d := 2.0*pow(c.r-tint.r, 2) + 4.0*pow(c.g-tint.g, 2) + 3.0*pow(c.b-tint.b, 2)
		if d < best_distance:
			best_distance = d
			best = index
	return best

static func _hue_distance(a: float, b: float) -> float:
	var d := absf(a-b)
	return minf(d, 1.0-d)

static func texture(tint: Color) -> Texture2D:
	var key := tint.to_html(false)
	if _cache.has(key): return _cache[key]
	var image := (load(path(5)) as Texture2D).get_image()
	if image.is_compressed(): image.decompress()
	image.convert(Image.FORMAT_RGBA8)
	for y in image.get_height():
		for x in image.get_width():
			var pixel := image.get_pixel(x,y)
			if pixel.a > .01 and pixel.s > .12 and pixel.h > .48 and pixel.h < .75:
				var shade := clampf(pixel.v/.78,.18,1.3)
				var painted := tint*minf(1,shade)
				if shade > 1: painted = tint.lerp(Color.WHITE,(shade-1)*.65)
				painted.a = pixel.a
				image.set_pixel(x,y,painted)
	var result := ImageTexture.create_from_image(image)
	_cache[key] = result
	return result

## White silhouette of the matching ant, drawn slightly larger under the body so dark
## palette ants stay readable against the dark museum wall.
static func halo(tint: Color) -> Texture2D:
	if _halos.has("outline"): return _halos["outline"]
	var image := texture(tint).get_image()
	image.convert(Image.FORMAT_RGBA8)
	var data := image.get_data()
	for i in range(0,data.size(),4):
		data[i] = 255; data[i+1] = 255; data[i+2] = 255
	var mask := Image.create_from_data(image.get_width(),image.get_height(),false,Image.FORMAT_RGBA8,data)
	_halos["outline"] = ImageTexture.create_from_image(mask)
	return _halos["outline"]

## Builds every scout texture for a level up front so the first launch never stutters.
static func warm(palette: Array) -> void:
	for tint in palette: texture(Color(tint))
