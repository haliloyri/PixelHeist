extends RefCounted
## Artwork tones are independent of the logical carrier matching group.
static func color_at(level: Dictionary, cell: int) -> Color:
	var colors: Array = level.get("cell_colors", [])
	if cell>=0 and cell<colors.size(): return Color(colors[cell])
	return Color(level.palette[int(level.cells[cell])])
