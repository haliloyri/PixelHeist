extends SceneTree
## Walks every r13 screen and pop-up and saves screenshots to artifacts/r13/.
var game
var n := 0
func _initialize() -> void: call_deferred("run")
func cap(label: String) -> void:
	for i in 4: await process_frame
	await RenderingServer.frame_post_draw
	n += 1
	var path := "res://artifacts/r13/%02d-%s.png" % [n, label]
	root.get_texture().get_image().save_png(path)
	print("CAP ", path, " screen=", game.screen, " modal=", game.modal_kind)
func solve() -> void:
	for column in game.current_level().solution:
		while game.busy and game.screen == "play": game._process(.1)
		game._deploy(int(column))
	var guard := 0
	while game.screen == "play" and guard < 6000:
		game._process(.1)
		guard += 1
func run() -> void:
	var dir := "user://capture_r13"
	DirAccess.make_dir_recursive_absolute(dir)
	for f in ["progress.cfg.v2", "progress.cfg.v2.bak"]:
		if FileAccess.file_exists(dir + "/" + f): DirAccess.remove_absolute(dir + "/" + f)
	game = load("res://scenes/main.tscn").instantiate()
	game.save_path = dir + "/progress.cfg"
	root.add_child(game)
	await cap("story-opening")
	game.screen_view._advance()
	await cap("heist-1-tip")
	solve()
	await cap("level-complete-1")
	game._complete_continue()
	await cap("safehouse")
	game._show_modal("settings"); await cap("p1-settings"); game._close_modal()
	game._open_daily(); await cap("p4-reward-daily"); game._close_modal()
	game._show_modal("offer"); await cap("p5-offer"); game._close_modal()
	game.store.apply(func(s): s.energy = 0; s.energy_at = game.store.now(); return true)
	game._play(); await cap("p3-out-of-energy"); game._close_modal()
	game.store.apply(func(s): s.energy = 10; return true)
	game._play(); await cap("heist-2")
	game._use_booster("extra_dock"); await cap("heist-2-extra-dock")
	game._show_modal("pause"); await cap("p1-pause"); game._close_modal()
	game._show_modal("out_of_space"); await cap("p2-out-of-space"); game._close_modal()
	game._show_modal("get_booster:scout_fly"); await cap("p6-get-booster"); game._close_modal()
	solve()
	game._complete_continue()
	for i in 3:
		game._play()
		solve()
		if i < 2: game._complete_continue()
	await cap("level-complete-finale")
	game._complete_continue()
	await cap("story-chapter-1-complete")
	game.screen_view._open_chest()
	await cap("story-chest-reward"); game._close_modal()
	await cap("story-panel-1")
	game.screen_view._skip()
	await cap("story-next-chapter")
	game.screen_view._advance()
	await cap("safehouse-after-chapter")
	game._show_gallery("paintings"); await cap("gallery-paintings")
	game.open_painting("sun_seal"); await cap("p7-painting"); game._close_modal()
	game._show_gallery("crew"); await cap("gallery-crew")
	game._show_shop(); await cap("shop")
	game.screen_view.scroll.scroll_vertical = 900
	await cap("shop-scrolled")
	# Chapter 20 ending choice (story only; its puzzles are not authored yet).
	game._show_story(20); game.screen_view._advance(); await cap("story-ending-choice")
	print("R13 CAPTURES: %d" % n)
	game.queue_free()
	await process_frame
	quit()
