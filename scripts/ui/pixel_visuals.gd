extends RefCounted
## Detailed presentation pixels; logical board cells and carrier colors are unchanged.
static var cache: Dictionary = {}

static func texture_for(level: Dictionary) -> Texture2D:
	var path: String = str(level.get("pixel_visual_path", ""))
	if path.is_empty(): return null
	if cache.has(path): return cache[path]
	if not ResourceLoader.exists(path): return null
	var texture: Texture2D = load(path)
	cache[path] = texture
	return texture

static func draw_cells(canvas: CanvasItem, level: Dictionary, cells: Array, area: Rect2, reveal: float = 1.0) -> void:
	var texture: Texture2D = texture_for(level)
	if texture == null or cells.is_empty(): return
	var width: int = int(level.width)
	var height: int = int(level.height)
	var tile := Vector2(area.size.x / width, area.size.y / height)
	var source_tile := Vector2(float(texture.get_width()) / width, float(texture.get_height()) / height)
	for index in cells.size():
		if int(cells[index]) < 0 or float(index) / cells.size() > reveal: continue
		var column := index % width
		var row := index / width
		var dest := Rect2(area.position + Vector2(column * tile.x, row * tile.y), tile)
		var source := Rect2(Vector2(column * source_tile.x, row * source_tile.y), source_tile)
		canvas.draw_texture_rect_region(texture, dest, source)
