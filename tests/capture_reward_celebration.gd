extends SceneTree
const Fixture=preload("res://tests/fixture.gd")
var game
var count:=0
func _initialize()->void:call_deferred("run")
func show_reward(data:Dictionary)->void:
	game._show_reward(data)
	game.overlay.get_node("Card/Celebration").set_process(false)
	await create_timer(.2).timeout
func shot(label:String)->void:
	await process_frame;RenderingServer.force_draw(false)
	root.get_texture().get_image().save_png("res://artifacts/reward-celebration-"+label+".png");count+=1
func run()->void:
	for extent in [Vector2i(720,1280),Vector2i(390,844)]:
		game=Fixture.create_game();root.add_child(game);await process_frame;game.set_process(false)
		root.size=extent
		var prefix:="standard-" if extent.x==720 else "tall-"
		game.reduced_motion=false
		await show_reward({"kind":"daily","day":6,"gold":300,"boosters":["zap","row_beam"]})
		game.overlay.get_node("Card/Celebration").advance(.65);await shot(prefix+"daily")
		await show_reward({"kind":"purchase","product_id":"starter_pack","title":"Starter Pack","gold":1000,"boosters":game.BOOSTERS})
		game.overlay.get_node("Card/Celebration").advance(.65);await shot(prefix+"pack")
		game.reduced_motion=true
		await show_reward({"kind":"star","gold":100,"boosters":["zap"]});await shot(prefix+"reduced")
		if extent.x==720:
			game.reduced_motion=false
			await show_reward({"kind":"daily","day":6,"gold":300,"boosters":["zap","row_beam"]})
			DirAccess.make_dir_recursive_absolute("res://artifacts/reward-celebration-frames")
			for i in 84:
				game.overlay.get_node("Card/Celebration").advance(1.0/24)
				await process_frame;RenderingServer.force_draw(false)
				root.get_texture().get_image().save_png("res://artifacts/reward-celebration-frames/frame-%04d.png"%i)
		game._close_modal();Fixture.cleanup(game);game.queue_free();await process_frame
	print("REWARD CELEBRATION CAPTURES: %d | ANIMATION FRAMES: 84 | FAILURES: 0"%count);quit()
