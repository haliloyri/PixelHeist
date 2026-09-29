extends RefCounted
## Carrier-drone skin built from the ten cube sprites in sc/assets/cube-asset.png
## (sliced, background removed, saved as assets/drones/cube_XX_<name>.png).
##
## Puzzle contract: a carrier must read as exactly its artwork colour. Level palettes
## are muted and often hold several similar tones (e.g. three blue-greys), so the raw
## cube colours cannot be used 1:1. The cube whose colour is nearest to the tint is
## taken as the base and recoloured to the exact tint, keeping its shading, outline
## and door glow. Set RECOLOR=false to show the raw cube colours instead.
const RECOLOR := true
const CUBES := [
	["brown", "a2553a"], ["red", "e23144"], ["white", "e6e6ec"], ["black", "424553"],
	["orange", "ed8723"], ["blue", "4c7dc8"], ["yellow", "f2b82f"], ["green", "4fb250"],
	["purple", "8d5ec5"], ["pink", "f870a0"],
]
## Vertical centre of the cube's top face, as a fraction of the sprite height above centre.
const TOP_FACE_LIFT := 0.14
static var _bases: Array = []
static var _cache: Dictionary = {}

static func path(index: int) -> String:
	return "res://assets/drones/cube_%02d_%s.png" % [index, CUBES[index][0]]

static func _load_bases() -> void:
	if not _bases.is_empty(): return
	for index in CUBES.size():
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
	for index in CUBES.size():
		var c := Color(CUBES[index][1])
		# Weighted RGB distance, close enough to perceptual for picking a base shape.
		var d := 2.0*pow(c.r-tint.r, 2) + 4.0*pow(c.g-tint.g, 2) + 3.0*pow(c.b-tint.b, 2)
		if d < best_distance:
			best_distance = d
			best = index
	return best

static func texture(tint: Color) -> Texture2D:
	var key := tint.to_html(false)
	if _cache.has(key): return _cache[key]
	_load_bases()
	var index := nearest(tint)
	var source: Image = _bases[index]
	var image: Image = source
	if RECOLOR:
		var reference := maxf(Color(CUBES[index][1]).get_luminance(), .05)
		var data := source.get_data()
		for i in range(0, data.size(), 4):
			if data[i+3] == 0: continue
			var luminance := (.2126*data[i] + .7152*data[i+1] + .0722*data[i+2]) / 255.0
			var k := luminance / reference
			var r := tint.r*k
			var g := tint.g*k
			var b := tint.b*k
			# Highlights brighter than the tint fade toward white instead of clipping.
			var over := clampf((maxf(r, maxf(g, b)) - 1.0)*.5, 0.0, .8)
			data[i] = int(clampf(lerpf(minf(r, 1.0), 1.0, over), 0.0, 1.0)*255.0)
			data[i+1] = int(clampf(lerpf(minf(g, 1.0), 1.0, over), 0.0, 1.0)*255.0)
			data[i+2] = int(clampf(lerpf(minf(b, 1.0), 1.0, over), 0.0, 1.0)*255.0)
		image = Image.create_from_data(source.get_width(), source.get_height(), false, Image.FORMAT_RGBA8, data)
	var result := ImageTexture.create_from_image(image)
	_cache[key] = result
	return result

## Builds every carrier texture for a level up front so the first deploy never stutters.
static func warm(palette: Array) -> void:
	for tint in palette: texture(Color(tint))
	texture(Color("687b91"))
