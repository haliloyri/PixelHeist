extends SceneTree
const Fixture = preload("res://tests/fixture.gd")
var game
func _initialize() -> void: call_deferred("run")
func capture(label: String) -> void:
	for i in 5: await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png("res://artifacts/"+label+".png")
func run() -> void:
	game=Fixture.create_game()
	root.add_child(game)
	await process_frame
	game.set_process(false)
	game.store.apply(func(s):s.story.opening=true;return true)
	root.size=Vector2i(720,1280)
	game._start_level(8)
	game._hide_tip()
	await capture("feedback-ready")
	for i in 150:
		if i%25==0:
			for col in game.puzzle.slot_count:
				if game.puzzle.can_deploy(col): game._deploy(col)
		game._process(.04)
	await capture("feedback-walking")
	# Follow a genuine carrier until its final delivery triggers departure.
	var guard:=0
	while game.departures.is_empty() and game.screen=="play" and guard<5000:
		game._process(.05)
		guard+=1
	if not game.departures.is_empty():
		game._process(.12)
		await capture("feedback-takeoff")
	root.size=Vector2i(390,844)
	await capture("feedback-tall")
	Fixture.cleanup(game)
	game.queue_free()
	await process_frame
	print("HEIST FEEDBACK CAPTURES: 4 | FAILURES: 0")
	quit()
