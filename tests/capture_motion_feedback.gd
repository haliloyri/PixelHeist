extends SceneTree
const Fixture=preload("res://tests/fixture.gd")
var game
var frame_index:=0
func _initialize()->void:call_deferred("run")
func frame()->void:
	# The deterministic capture must advance even when another window has focus.
	game.app_suspended=false
	game._process(1.0/24)
	await process_frame
	# Force an offscreen render even if macOS occludes/throttles the preview window.
	RenderingServer.force_draw(false)
	root.get_texture().get_image().save_png("res://artifacts/motion-frames/frame-%04d.png" % frame_index)
	frame_index+=1
func run()->void:
	DirAccess.make_dir_recursive_absolute("res://artifacts/motion-frames")
	game=Fixture.create_game()
	root.add_child(game)
	await process_frame
	game.set_process(false)
	game.app_suspended=false
	game.store.apply(func(s):s.story.opening=true;s.boosters.row_beam=3;return true)
	game._start_level(8)
	game._hide_tip()
	game._deploy(0)
	for i in 100:game._process(.04)
	game.speed=1
	for i in 48:await frame()
	game._toggle_speed()
	for i in 48:await frame()
	# A second shot shows a real beam action while the boxes wait on their platforms.
	game._start_level(8)
	game._hide_tip()
	for i in 6:await frame()
	game._deploy(0)
	game._deploy(2)
	game._use_booster("row_beam")
	if game.beam_effects.size()<10:
		printerr("FAIL: Preview must show a full row transfer")
		quit(1)
		return
	for i in 54:await frame()
	if not game.beam_effects.is_empty():
		printerr("FAIL: Preview simulation did not finish the transfer")
		quit(1)
		return
	Fixture.cleanup(game)
	game.queue_free()
	await process_frame
	print("MOTION CAPTURE: %d frames | FAILURES: 0" % frame_index)
	quit()
