@tool
extends Control
## Shared tile renderer for the board, mission cards, and recovered works.
@export_range(-1, 14) var preview_level: int = -1:
	set(value):
		preview_level = value
		if is_inside_tree(): _load_preview()
var level: Dictionary = {}
var cells: Array = []
var reveal := 1.0
## Presentation-only zoom (heist-v2 "shrink the painting" follow-up, 2026-09-23). Only affects
## what is drawn; art_rect()/cell_position() keep returning the full, unshrunk rect so every
## consumer of board geometry (next_pick tie-break origins, route distances/timing, tile_size)
## is completely unaffected. Defaults to 1.0 (no change) for every other screen that reuses
## this renderer (mission cards, recovered works, etc).
@export_range(0.1, 1.0) var visual_scale := 1.0:
	set(value):
		visual_scale = value
		queue_redraw()

func _ready() -> void:
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	resized.connect(queue_redraw)
	_load_preview()

func _load_preview() -> void:
	if preview_level >= 0:
		var levels: Array = JSON.parse_string(FileAccess.get_file_as_string("res://data/levels.json"))
		level = levels[preview_level]
		cells = []
	queue_redraw()

func art_rect() -> Rect2:
	if level.is_empty():
		return Rect2()
	var tile := minf(size.x / float(level.width), size.y / float(level.height))
	var extent := Vector2(float(level.width), float(level.height)) * tile
	return Rect2((size - extent) * 0.5, extent)

func cell_position(index: int) -> Vector2:
	var area := art_rect()
	var tile := area.size.x / float(level.width)
	return position + area.position + Vector2(index % int(level.width) + 0.5,
		floori(float(index) / float(level.width)) + 0.5) * tile

## Presentation-only shrunk-and-recentred rect (visual_scale above). The board's ACTUAL
## on-screen renderer in "play" is depth_heist.gd's voxel projection (board_art/pixel_art.gd's
## own _draw() is hidden there -- see main.gd's "board_art.visible=false"), so depth_heist.gd
## reads this instead of art_rect() for anything that should visually shrink with the painting.
## art_rect()/cell_position() above are UNCHANGED and stay the source of truth for next_pick()
## tie-break origins and route/flight-timing math (main.gd) -- those must never see this.
func visual_rect() -> Rect2:
	var area := art_rect()
	if visual_scale >= 1.0 or level.is_empty(): return area
	var tile := area.size.x / float(level.width)
	var full_extent := Vector2(float(level.width),float(level.height))*tile
	var shown_extent := full_extent*visual_scale
	return Rect2(area.position+(full_extent-shown_extent)*0.5,shown_extent)

## Shrunk-and-recentred counterpart to cell_position(), for the same visual-only reason.
func visual_cell_position(index: int) -> Vector2:
	var area := visual_rect()
	var tile := area.size.x / float(level.width)
	return position + area.position + Vector2(index % int(level.width) + 0.5,
		floori(float(index) / float(level.width)) + 0.5) * tile

func _draw() -> void:
	if level.is_empty():
		return
	var area := visual_rect()
	var tile := area.size.x / float(level.width)
	var source: Array = cells if not cells.is_empty() else level.cells
	if level.has("pixel_visual_path"):
		preload("res://scripts/ui/pixel_visuals.gd").draw_cells(self, level, source, area, reveal)
		return
	var raised: bool = level.get("pixel_style", "") == "raised_blocks"
	if raised: draw_rect(area,Color(level.board_backing))
	for i in source.size():
		var color_id := int(source[i])
		if color_id < 0 or float(i) / source.size() > reveal:
			continue
		var shade := preload("res://scripts/ui/artwork_pixels.gd").color_at(level,i)
		var point := area.position + Vector2(i % int(level.width), floori(float(i) / float(level.width))) * tile
		if raised:
			preload("res://scripts/ui/raised_pixel.gd").draw_pixel(self,point+Vector2.ONE*tile*.5,tile,shade)
			continue
		var bevel := maxf(0.35, tile * 0.045)
		draw_rect(Rect2(point, Vector2.ONE * tile), shade.darkened(0.20))
		draw_rect(Rect2(point + Vector2.ONE * bevel * .5, Vector2.ONE * (tile - bevel * 1.5)), shade)
		if tile > 7:
			draw_line(point + Vector2(bevel, bevel), point + Vector2(tile - bevel, bevel), shade.lightened(.10), bevel)
