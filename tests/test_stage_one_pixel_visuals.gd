extends SceneTree
const Fixture = preload("res://tests/fixture.gd")
const Art = preload("res://scripts/ui/museum_art.gd")
const Visuals = preload("res://scripts/ui/pixel_visuals.gd")
const Content = preload("res://scripts/services/content_catalog.gd")
var checks := 0
var failures := 0

func check(ok: bool, message: String) -> void:
	checks += 1
	if not ok:
		failures += 1
		printerr("FAIL: ", message)

func _initialize() -> void: call_deferred("run")

func run() -> void:
	var game = Fixture.create_game()
	root.add_child(game)
	await process_frame
	game.set_process(false)
	game.app_suspended = false
	game.store.apply(func(s): s.story.opening = true; return true)
	var ids: Array = ["girl_with_a_pearl_earring", "starry_night", "moon_gate_mask", "mona_lisa", "the_kiss", "the_scream", "birth_of_venus", "water_lilies"]
	var catalog := Content.new()
	for art_id in ids:
		var level: Dictionary = game.level_for(art_id)
		var visual: Texture2D = Visuals.texture_for(level)
		check(visual != null and visual.get_height() == 32, art_id + " readable large-pixel texture")
		var without_visual: Dictionary = level.duplicate(true)
		without_visual.erase("pixel_visual_path")
		check(catalog.fingerprint(level) == catalog.fingerprint(without_visual), art_id + " save fingerprint unchanged")
		var art := Art.new()
		root.add_child(art)
		art.setup(game, art_id, true, Vector2(400, 500), false)
		check(art.get_child(0) is TextureRect, art_id + " Museum uses detailed texture")
		art.queue_free()
	for index in range(2, 10):
		var level: Dictionary = game.levels[index]
		game._start_level(index)
		check(game.depth_view.visual_overlay != null, level.art_id + " heist uses visual layer")
		var playable: int = level.cells.filter(func(cell): return int(cell) >= 0).size()
		check(game.puzzle.total == playable, level.art_id + " puzzle cell count unchanged")
		check(game.heist_checkpoint.validate(game.heist_checkpoint.capture(game), game.levels).is_empty(), level.art_id + " checkpoint valid")
		game.puzzle.board[0] = -1
		game.depth_view.sync()
		check(game.depth_view.visual_overlay.is_queued_for_deletion() == false, level.art_id + " overlay follows board")
	Fixture.cleanup(game)
	game.queue_free()
	await process_frame
	print("STAGE ONE PIXEL VISUALS CHECKS: %d | FAILURES: %d" % [checks, failures])
	quit(1 if failures else 0)
