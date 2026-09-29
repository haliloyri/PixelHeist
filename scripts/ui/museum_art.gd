extends Control
## Shared original/pixel presentation for museum walls, details and export.
const PixelArt = preload("res://scripts/ui/pixel_art.gd")
const PixelVisuals = preload("res://scripts/ui/pixel_visuals.gd")
const Originals = preload("res://scripts/ui/heist_intro.gd")
const Kit = preload("res://scripts/ui/ui_kit.gd")
const FONT = preload("res://assets/fonts/Lora-700.ttf")
var picture_rect := Rect2()
var pixels_mode := false
func setup(game, art_id: String, pixels: bool, extent: Vector2, caption := true) -> void:
	for child in get_children():
		remove_child(child)
		child.queue_free()
	size=extent
	mouse_filter=Control.MOUSE_FILTER_IGNORE
	var texture: Texture2D = Originals.artwork_texture(art_id)
	var level: Dictionary = game.level_for(art_id)
	# New originals have no pixel board yet. Never manufacture one for a preview.
	pixels = pixels and not level.is_empty()
	pixels_mode = pixels
	var available := extent-Vector2(24,54 if caption else 24)
	var source := Vector2(float(level.get("width",1)),float(level.get("height",1)))
	var detailed: Texture2D = PixelVisuals.texture_for(level) if pixels else null
	if detailed != null: source = detailed.get_size()
	if not pixels and texture!=null: source=texture.get_size()
	var fitted := source*minf(available.x/source.x,available.y/source.y)
	picture_rect=Rect2(Vector2((extent.x-fitted.x)*.5,12+(available.y-fitted.y)*.5),fitted)
	var view: Control
	if detailed != null:
		var image:=TextureRect.new()
		image.texture=detailed
		image.expand_mode=TextureRect.EXPAND_IGNORE_SIZE
		image.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		image.texture_filter=CanvasItem.TEXTURE_FILTER_NEAREST
		view=image
	elif pixels:
		var art:=PixelArt.new()
		art.level=level
		view=art
	else:
		var image:=TextureRect.new()
		image.texture=texture
		image.expand_mode=TextureRect.EXPAND_IGNORE_SIZE
		image.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		view=image
	add_child(view)
	view.mouse_filter=Control.MOUSE_FILTER_IGNORE
	view.position=picture_rect.position
	view.size=picture_rect.size
	if caption:
		var caption_rect:=Rect2(4,minf(extent.y-35,picture_rect.end.y+12),extent.x-8,32)
		var label:=Kit.label(self,game.art_title(art_id),caption_rect,18,Color("f4dfb5"),1)
		label.add_theme_font_override("font",FONT)
		label.clip_text=true
		label.size=caption_rect.size
		preload("res://scripts/services/localization.gd").fit(label,18,12)
	queue_redraw()
func _draw()->void:
	if picture_rect.size==Vector2.ZERO:return
	draw_rect(Rect2(picture_rect.position+Vector2(3,7)-Vector2.ONE*13,picture_rect.size+Vector2.ONE*26),Color(0,0,0,.45))
	draw_rect(picture_rect.grow(11),Color("51351d"))
	draw_rect(picture_rect.grow(9),Color("d3a75d"))
	draw_rect(picture_rect.grow(6),Color("84602f"))
	draw_rect(picture_rect.grow(3),Color("f0d291"))
	draw_rect(picture_rect.grow(1),Color("10191c"))
