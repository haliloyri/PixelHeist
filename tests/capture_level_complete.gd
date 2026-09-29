extends SceneTree
const Fixture=preload("res://tests/fixture.gd")
var game
var count:=0
func _initialize()->void:call_deferred("run")
func show_win(id:String,stars:int,crew:String="")->void:
	game.last_win=game.store.record_win(id,"",stars)
	game.last_win.merge({"art_id":id,"crew":crew,"double_used":false})
	game._show_complete();game.screen_view.set_process(false)
func shot(label:String)->void:
	for i in 3:await process_frame
	RenderingServer.force_draw(false)
	root.get_texture().get_image().save_png("res://artifacts/victory-"+label+".png");count+=1
func run()->void:
	for extent in [Vector2i(720,1280),Vector2i(390,844)]:
		game=Fixture.create_game();root.add_child(game);await process_frame;game.set_process(false)
		game.store.apply(func(s):s.story.opening=true;return true)
		root.size=extent
		var prefix:="standard-" if extent.x==720 else "tall-"
		game.reduced_motion=false;show_win("sun_seal",3)
		game.screen_view.advance_celebration(.65);await shot(prefix+"burst")
		game.screen_view.advance_celebration(4);await shot(prefix+"settled")
		for id in game.campaign.order().slice(1,4):game.store.record_win(id,"",3)
		show_win("moon_gate_mask",3,"bit");game.screen_view.advance_celebration(4);await shot(prefix+"crew")
		game.reduced_motion=true;show_win("the_gleaners",2);await shot(prefix+"reduced")
		for id in game.campaign.order():game.store.record_win(id,"",3)
		show_win("sun_seal",1);await shot(prefix+"replay")
		if extent.x==720:
			DirAccess.make_dir_recursive_absolute("res://artifacts/victory-frames")
			game.reduced_motion=false;show_win("starry_night",3)
			for i in 84:
				game.screen_view.advance_celebration(1.0/24)
				await process_frame;RenderingServer.force_draw(false)
				root.get_texture().get_image().save_png("res://artifacts/victory-frames/frame-%04d.png"%i)
		Fixture.cleanup(game);game.queue_free();await process_frame
	print("LEVEL COMPLETE CAPTURES: %d | ANIMATION FRAMES: 84 | FAILURES: 0"%count);quit()
