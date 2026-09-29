extends SceneTree
const Fixture=preload("res://tests/fixture.gd")
var game
var count:=0
func _initialize()->void:call_deferred("run")
func open_archive()->Control:
	game._show_lobby();game.screen_view.get_node("CaseFile").pressed.emit()
	return game.screen_view.archive_view
func shot(label:String)->void:
	for i in 5:await process_frame
	RenderingServer.force_draw(false)
	root.get_texture().get_image().save_png("res://artifacts/case-file-"+label+".png");count+=1
func run()->void:
	for extent in [Vector2i(720,1280),Vector2i(390,844)]:
		game=Fixture.create_game();root.add_child(game);await process_frame;game.set_process(false);root.size=extent
		var prefix:="standard-" if extent.x==720 else "tall-"
		game._show_story(0);await shot(prefix+"live-opening")
		var view=open_archive();await shot(prefix+"active-directory")
		view.open_stage(1);await shot(prefix+"active-opening")
		for id in game.campaign.order().slice(0,10):game.store.record_win(id,"",3)
		game._show_story(2);await shot(prefix+"live-finale")
		view=open_archive();await shot(prefix+"completed-directory")
		view.open_stage(1);await shot(prefix+"completed-opening")
		view.next_scene();await shot(prefix+"completed-finale")
		Fixture.cleanup(game);game.queue_free();await process_frame
	print("CASE FILE CAPTURES: %d | FAILURES: 0"%count);quit()
