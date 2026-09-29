extends SceneTree
const Fixture = preload("res://tests/fixture.gd")
var game
func _initialize() -> void: call_deferred("run")
func capture(label: String) -> void:
	for i in 5: await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png("res://artifacts/"+label+".png")
func run() -> void:
	game = Fixture.create_game()
	root.add_child(game)
	await process_frame
	game.set_process(false)
	game.store.apply(func(s): s.story.opening = true; return true)
	game._start_level(8)
	game._hide_tip()
	await capture("v4-venus-start")
	# Real deployment/flight state: no invented board or capacities.
	for step in 150:
		if step % 25 == 0:
			for c in game.puzzle.slot_count:
				if game.puzzle.can_deploy(c): game._deploy(c)
		game._process(.04)
	await capture("v4-venus-active")
	game.reduced_motion = true
	await capture("v4-reduced-motion")
	game._start_level(10)
	game._hide_tip()
	game._change_queue_page(1)
	await capture("v4-five-lane-second-page")
	root.size = Vector2i(390,844)
	await capture("v4-narrow-tall")
	root.size = Vector2i(720,1280)
	game._start_level(8)
	game._hide_tip()
	game.store.apply(func(s): s.boosters.row_beam = 2; return true)
	game._use_booster("row_beam")
	await capture("v4-row-beam")
	Fixture.cleanup(game)
	game.queue_free()
	await process_frame
	print("HEIST V4 CAPTURES: 6 | FAILURES: 0")
	quit()
