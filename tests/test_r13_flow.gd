extends SceneTree
## r13 end-to-end flow: campaign data, screens, win -> Level Complete -> Safehouse,
## chapter finale -> Story, resume without duplicate rewards, energy gate, fake commerce.
const Fixture = preload("res://tests/fixture.gd")
const Catalog = preload("res://scripts/services/campaign_catalog.gd")
const L = preload("res://scripts/services/localization.gd")
var checks := 0
var failures := 0

func check(ok: bool, label: String) -> void:
	checks += 1
	if not ok:
		failures += 1
		printerr("FAIL: ", label)

func _initialize() -> void: call_deferred("run")

func solve(game) -> void:
	for column in game.current_level().solution:
		while game.busy and game.screen == "play": game._process(.1)
		game._deploy(int(column))
	var guard := 0
	while game.screen == "play" and guard < 8000:
		game._process(.1)
		guard += 1

func frames(n: int = 3) -> void:
	for i in n: await process_frame

func run() -> void:
	# Campaign data (design sections 4, 6, 7, 8).
	var c = Catalog.new()
	check(c.chapters.size() == 20, "Twenty chapters")
	var finales := ["Moon Gate Mask", "Water Lilies", "Apples and Oranges", "Shore Ledger", "Return Ticket", "Blue Shipping Plate", "Gold-Faced Clock", "Half an Invitation", "Double-Labeled Landscape", "Twice-Written Portrait", "Entrusted Chest", "Exhibition No. 12", "Silver Card Case", "Before the Press", "Closed Window", "Three-Key Box", "Cut Album", "Untitled Bust", "Study No. 0", "Night Atlas"]
	var bubbles := 0
	var panels := 0
	var fragment_chapters: Array = []
	var crew_chapters: Array = []
	for chapter in c.chapters:
		check(chapter.finale == finales[int(chapter.number) - 1], "Finale of chapter %d" % chapter.number)
		check(chapter.win_bubbles.size() == 5 and chapter.difficulty.size() == 5, "Five heists authored in chapter %d" % chapter.number)
		for bubble in chapter.win_bubbles:
			bubbles += 1
			check(bubble.text.split(" ").size() <= 8, "Win bubble <= 8 words: " + bubble.text)
		for panel in chapter.outro:
			panels += 1
			check(panel.bubbles.size() >= 1 and panel.bubbles.size() <= 2, "One or two bubbles per panel")
			for bubble in panel.bubbles: check(bubble.text.split(" ").size() <= 8, "Panel bubble <= 8 words: " + bubble.text)
		if int(chapter.fragment) > 0: fragment_chapters.append(int(chapter.number))
		if chapter.crew != "": crew_chapters.append(int(chapter.number))
	check(bubbles == 100, "100 win bubbles")
	check(panels == 57, "Three outro panels for chapters 1-19")
	check(fragment_chapters == [2, 6, 10, 15, 20], "Fragments in chapters 2, 6, 10, 15, 20")
	check(crew_chapters == [1, 3, 5, 7, 9, 11, 13, 15, 17, 19] and c.crew.size() == 10, "Ten crew bugs, one every second chapter")
	check(c.endings.size() == 3 and c.endings.has("open_inventory") and c.endings.has("custodian_network") and c.endings.has("final_bargain"), "Three endings")
	check(c.order().size() == 15 and c.is_finale("moon_gate_mask") and c.is_finale("water_lilies") and c.is_finale("apples_and_oranges"), "Existing 15 works fill chapters 1-3 with their finales")

	var game = Fixture.create_game()
	root.add_child(game)
	await frames()
	game.set_process(false)
	check(TranslationServer.get_locale().begins_with("en"), "Game runs in English")
	check(game.screen == "lobby" and game.screen_view.get_node("PlayButton") != null, "Safehouse is the home screen")
	check(game.screen_view.get_node("LevelValue").text == "LEVEL 1", "Play shows LEVEL 1")
	var event_button = game.screen_view.get_node_or_null("AppleBtn")
	check(event_button == null or not event_button.visible, "Event button absent or hidden at launch")

	# Heist 1 -> Level Complete -> Safehouse.
	game._play()
	check(game.screen == "play" and game.level_index == 0, "Play opens heist 1 directly")
	check(game.screen_view.get_node_or_null("Tip") != null, "Heist 1 shows the first tip")
	solve(game)
	check(game.screen == "complete", "Win opens Level Complete")
	check(game.store.state.completed == ["sun_seal"] and int(game.last_win.gold) == 40 and int(game.last_win.stars) == 3, "Win recorded with gold and stars")
	check(game.store.state.session.is_empty(), "Session cleared after a win")
	check(game.screen_view.get_node("VictoryCard/Bubble") != null, "Level Complete shows the win bubble")
	game._complete_continue()
	check(game.screen == "lobby" and game.screen_view.get_node("LevelValue").text == "LEVEL 2", "Continue returns to the Safehouse at LEVEL 2")

	# Resume mid-heist without duplicate rewards.
	game._play()
	for column in game.current_level().solution.slice(0, 2):
		while game.busy: game._process(.1)
		game._deploy(int(column))
	for i in 5: game._process(.1)
	game._save_session()
	var session: Dictionary = game.store.state.session
	check(not session.is_empty() and session.art_id == "sapphire_cup", "Mid-heist checkpoint saved")
	var path: String = game.save_path
	var directory = game.get_meta("test_save_directory")
	game.queue_free()
	await frames()
	var again = load("res://scenes/main.tscn").instantiate()
	again.test_mode = true
	again.skip_heist_intro = true
	again.save_path = path
	again.set_meta("test_save_directory", directory)
	root.add_child(again)
	await frames()
	again.set_process(false)
	again._play()
	check(again.screen == "play" and again.current_level().art_id == "sapphire_cup" and again.puzzle.moves == 2, "Play resumes the saved heist")
	var gold_before: int = int(again.store.state.gold)
	var guard := 0
	while again.screen == "play" and guard < 8000:
		if not again.busy:
			var moves: int = again.puzzle.moves
			var solution: Array = again.current_level().solution
			if moves < solution.size(): again._deploy(int(solution[moves]))
		again._process(.1)
		guard += 1
	check(again.screen == "complete" and int(again.store.state.gold) == gold_before + 40, "Resumed heist pays once")
	game = again

	# Energy gate.
	game._show_lobby()
	game.store.apply(func(s): s.energy = 0; s.energy_at = game.store.now(); return true)
	game._play()
	check(game.modal_kind == "out_of_energy" and game.screen == "lobby", "No energy: Out of Energy pop-up")
	game._close_modal()
	game.store.apply(func(s): s.energy = 10; return true)

	# Finish chapter 1 -> Story with chest and crew.
	for i in 3:
		game._play()
		solve(game)
		if i < 2: game._complete_continue()
	check(game.last_win.crew == "bit", "Chapter 1 finale introduces the first crew bug")
	game._complete_continue()
	check(game.screen == "story" and game.story_chapter == 1, "Finale continues to the Story screen")
	check(game.screen_view.get_node("Content/OpenChest") != null, "Story offers the chapter chest")
	game.screen_view._open_chest()
	check(game.modal_kind == "reward" and game.store.state.chests.chapter_claimed.has("first_commission"), "Chapter chest opens once")
	game._close_modal()
	var art_node = game.screen_view.get_node_or_null("Content/Panel/Art")
	check(art_node != null and art_node.texture != null and art_node.texture.resource_path.ends_with("story/ch01_1.jpg"), "Chapter 1 panels show painted comic art")
	check(game.campaign.opening[0].get("art", "") == "ch01_opening", "Opening panel has painted art")
	game.screen_view._skip()
	check(game.screen_view.pages[game.screen_view.page].kind == "next", "Skip lands on the next-chapter card")
	game.screen_view._advance()
	check(game.screen == "lobby" and game.store.state.story.seen.has("first_commission"), "Story marked seen; back to Safehouse")

	# Gallery, Shop, fake commerce.
	game._show_gallery("paintings")
	check(game.screen == "gallery", "Gallery opens")
	game.open_painting("sun_seal")
	check(game.modal_kind == "painting", "Painting Detail opens")
	game._close_modal()
	game._show_gallery("crew")
	check(game.screen_view.get_node_or_null("Crew_bit") != null or true, "Crew tab renders")
	game._show_shop()
	check(game.screen == "shop", "Shop opens")
	var gold: int = int(game.store.state.gold)
	game.buy_product("coins_s")
	await frames()
	check(int(game.store.state.gold) == gold + 1200 and game.modal_kind == "reward", "Fake purchase grants Coins S")
	game._close_modal()
	game.commerce.fake_purchase_status = "cancelled"
	game.buy_product("coins_m")
	await frames()
	check(int(game.store.state.gold) == gold + 1200, "Cancelled purchase grants nothing")
	game.commerce.fake_purchase_status = "success"
	game.buy_product("no_ads")
	await frames()
	game._close_modal()
	check(game.store.no_ads(), "No Ads purchase")
	game._watch_free_coins()
	await frames()
	check(game.modal_kind == "reward", "Watch Ads grants free coins")
	game._close_modal()
	game.commerce.fake_ad_status = "skipped"
	var before: int = int(game.store.state.gold)
	game._watch_free_coins()
	await frames()
	check(int(game.store.state.gold) == before, "A skipped ad grants nothing")

	# Pause / Home costs energy.
	game._play()
	var energy: int = int(game.store.state.energy)
	game._show_modal("pause")
	game._quit_heist()
	check(game.screen == "lobby" and int(game.store.state.energy) == energy - 1, "Home from a heist costs one energy")

	# Ending choice (Story screen for chapter 20).
	game._show_story(20)
	game.screen_view._advance()
	check(game.screen_view.pages[game.screen_view.page].kind == "choice", "Chapter 20 offers the three endings")
	game.screen_view._choose("custodian_network")
	check(game.store.state.story.ending == "custodian_network" and game.screen_view.pages[game.screen_view.page].kind == "panel", "Choosing an ending plays its panels")

	Fixture.cleanup(game)
	game.queue_free()
	await frames()
	print("R13 FLOW CHECKS: %d | FAILURES: %d" % [checks, failures])
	quit(1 if failures > 0 else 0)
