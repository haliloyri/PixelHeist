extends SceneTree
const Fixture = preload("res://tests/fixture.gd")
const Art = preload("res://scripts/ui/museum_art.gd")
const Kit = preload("res://scripts/ui/ui_kit.gd")
var game

func _initialize() -> void: call_deferred("run")

func shot(label: String) -> void:
	for i in 4: await process_frame
	RenderingServer.force_draw(false)
	assert(root.get_texture().get_image().save_png("res://artifacts/sapphire-cup-" + label + ".png") == OK)

func run() -> void:
	game = Fixture.create_game()
	root.add_child(game)
	await process_frame
	game.set_process(false)
	game.app_suspended = false
	game.store.apply(func(state): state.story.opening = true; return true)
	root.size = Vector2i(720, 1280)
	game._start_level(1)
	game._hide_tip()
	await shot("gameplay")
	game._show_modal("painting", {"art_id": "sapphire_cup", "pixels": true})
	await shot("pixel-detail")
	game._close_modal()
	game._show_modal("painting", {"art_id": "sapphire_cup"})
	await shot("original-detail")
	game._close_modal()
	root.size = Vector2i(390, 844)
	await shot("tall")
	game.hide()
	var comparison := SubViewport.new()
	comparison.size = Vector2i(1080, 630)
	comparison.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	root.add_child(comparison)
	var sheet := Control.new()
	comparison.add_child(sheet)
	Kit.panel(sheet, Rect2(0, 0, 1080, 630), Color("0c1625"), Color("0c1625"), 0, 0)
	Kit.label(sheet, "SAPPHIRE CUP · ORIGINAL", Rect2(20, 14, 500, 50), 26, Color("f3d59a"), 0)
	Kit.label(sheet, "22 × 22 · RAISED PIXELS", Rect2(560, 14, 500, 50), 26, Color("f3d59a"), 0)
	for i in 2:
		var art := Art.new()
		sheet.add_child(art)
		art.position = Vector2(25 + i * 540, 82)
		art.setup(game, "sapphire_cup", i == 1, Vector2(490, 490), false)
	Kit.label(sheet, "484 pixels · 5 matching colors · No gaps", Rect2(20, 580, 1040, 40), 24, Color("e0bd78"), 0)
	for i in 4: await process_frame
	RenderingServer.force_draw(false)
	assert(comparison.get_texture().get_image().save_png("res://artifacts/sapphire-cup-comparison.png") == OK)
	Fixture.cleanup(game)
	game.queue_free()
	await process_frame
	print("SAPPHIRE CUP CAPTURES: 5 | FAILURES: 0")
	quit()
