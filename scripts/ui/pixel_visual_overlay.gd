extends Control
## S2 presentation layer over the existing 3D logical cubes.
const Visuals = preload("res://scripts/ui/pixel_visuals.gd")
var game: Control

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	size = Vector2(720, 1280)

func _draw() -> void:
	if not is_instance_valid(game) or not is_instance_valid(game.board_art): return
	var area: Rect2 = game.board_art.visual_rect()
	area.position += game.board_art.position
	Visuals.draw_cells(self, game.current_level(), game.puzzle.board, area)
