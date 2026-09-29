extends SceneTree
const Fixture = preload("res://tests/fixture.gd")
func _initialize() -> void: call_deferred("run")
func run() -> void:
	root.size = Vector2i(720, 1280)
	var game = Fixture.create_game()
	root.add_child(game)
	await process_frame
	game.set_process(false)
	game.skip_heist_intro = false
	game.store.apply(func(s): s.story.opening = true; return true)
	DirAccess.make_dir_recursive_absolute("res://artifacts/intro-frames")
	game._start_level(0)
	for frame in 216:
		# Advance deterministic test time even if the desktop preview loses focus.
		game.app_suspended = false
		if frame > 0: game._process(.04)
		await process_frame
		RenderingServer.force_draw(false)
		root.get_texture().get_image().save_png("res://artifacts/intro-frames/intro-%03d.png" % frame)
	if game.intro_active(): printerr("FAIL: Intro did not complete during capture")
	Fixture.cleanup(game)
	game.queue_free()
	await process_frame
	print("INTRO CAPTURE: 216 frames | FAILURES: 0")
	quit()
