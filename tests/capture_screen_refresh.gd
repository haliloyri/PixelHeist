extends SceneTree
const Fixture=preload("res://tests/fixture.gd")
var game
var count:=0
func _initialize()->void:call_deferred("run")
func shot(label:String)->void:
	for i in 5:await process_frame
	RenderingServer.force_draw(false)
	root.get_texture().get_image().save_png("res://artifacts/refresh-"+label+".png")
	count+=1
func run()->void:
	for extent in [Vector2i(720,1280),Vector2i(390,844)]:
		game=Fixture.create_game();root.add_child(game);await process_frame;game.set_process(false)
		game.store.apply(func(s):s.story.opening=true;return true)
		root.size=extent
		var prefix:="standard-" if extent.x==720 else "tall-"
		game._show_lobby();game.screen_view._toggle_rewards();await shot(prefix+"rewards");game.screen_view._close_rewards()
		game._show_modal("settings");await shot(prefix+"settings")
		game._toggle_setting("reduced_motion");await shot(prefix+"settings-motion");game._close_modal()
		game._show_reward({"kind":"daily","day":6,"gold":int(game.store.rules.daily[6].gold),"boosters":["zap","row_beam"]});await shot(prefix+"daily");game._close_modal()
		game._show_reward({"kind":"purchase","product_id":"starter_pack","title":"Starter Pack","gold":1000,"boosters":game.BOOSTERS});await shot(prefix+"receipt");game._close_modal()
		game._show_gallery("crew");await shot(prefix+"crew-locked")
		for id in game.campaign.order():game.store.record_win(id,"",3)
		game.store.equip_crew(game.store.unlocked_crew()[0]);game.screen_view.refresh();await shot(prefix+"crew")
		game.screen_view.content.get_node("CrewScroll").scroll_vertical=9999;await shot(prefix+"crew-bottom")
		game._show_lobby();game.screen_view._toggle_rewards();await shot(prefix+"rewards-ready");game.screen_view._close_rewards()
		game._open_daily();game._close_modal();game.screen_view._toggle_rewards();await shot(prefix+"rewards-claimed");game.screen_view._close_rewards()
		game._replay_artwork("sun_seal");game._show_modal("pause");await shot(prefix+"pause");game._close_modal();game._show_lobby()
		Fixture.cleanup(game);game.queue_free();await process_frame
	print("SCREEN REFRESH CAPTURES: %d | FAILURES: 0"%count)
	quit()
