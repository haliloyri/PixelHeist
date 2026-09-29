extends SceneTree
const Fixture = preload("res://tests/fixture.gd")
var game

func _initialize() -> void: call_deferred("run")

func shot(label: String) -> void:
	for i in 4: await process_frame
	RenderingServer.force_draw(false)
	assert(root.get_texture().get_image().save_png("res://artifacts/stage1-visual-" + label + ".png") == OK)

func run() -> void:
	game = Fixture.create_game()
	root.add_child(game)
	await process_frame
	game.set_process(false)
	game.app_suspended = false
	game.store.apply(func(state): state.story.opening = true; return true)
	root.size = Vector2i(720, 1280)
	game._start_level(2)
	await shot("girl-heist")
	for i in 60: game.puzzle.board[i] = -1
	game.depth_view.sync()
	await shot("girl-collected")
	game._show_modal("painting", {"art_id": "girl_with_a_pearl_earring", "pixels": true})
	await shot("girl-detail")
	game._close_modal()
	game._start_level(4)
	await shot("mask-heist")
	game._show_modal("painting", {"art_id": "moon_gate_mask", "pixels": true})
	await shot("mask-detail")
	game._close_modal()
	for id in game.campaign.order().slice(0, 10): game.store.record_win(id, "", 3)
	game._show_gallery("paintings")
	game.screen_view.floor_number = 1
	game.screen_view.refresh()
	game.screen_view._toggle_pixels()
	await shot("gallery")
	Fixture.cleanup(game)
	game.queue_free()
	await process_frame
	print("STAGE ONE VISUAL CAPTURES: 6 | FAILURES: 0")
	quit()
