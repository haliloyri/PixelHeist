extends SceneTree
const Fixture = preload("res://tests/fixture.gd")
const Checkpoint = preload("res://scripts/services/heist_checkpoint.gd")
var checks := 0
var failures := 0
func check(ok: bool, label: String) -> void:
	checks += 1
	if not ok:
		failures += 1
		printerr("FAIL: ", label)
func _initialize() -> void: call_deferred("run")
func run() -> void:
	var game = Fixture.create_game()
	root.add_child(game)
	await process_frame
	game.set_process(false)
	for level in game.levels:
		check(game.HeistIntro.artwork_texture(level.art_id) != null, "Every playable work has its own original: " + level.art_id)
	game.skip_heist_intro = false
	game.store.apply(func(s): s.story.opening = true; s.boosters.row_beam = 3; return true)
	game._start_level(0)
	check(game.intro_active(), "Fresh first heist shows the original artwork")
	check(game.heist_intro.BEE_COUNT == 10, "Carrier releases exactly ten scouts")
	var intro = game.heist_intro
	check(intro.carrier_position(intro.ARRIVAL_START).y > game.size.y, "Carrier enters from below the viewport")
	check(intro.carrier_position(intro.DEPARTURE_END).y < -130, "Carrier exits above the viewport")
	check(intro.scouts_outside(intro.SCAN_START) == 10, "All ten scouts leave the hatch before conversion")
	var before_board: Array = game.puzzle.board.duplicate()
	var before_timers: Array = game.queue_remaining.duplicate()
	var stock: int = game.store.booster_count("row_beam")
	game._deploy(0)
	game._use_booster("row_beam")
	var speed: int = game.speed
	game._toggle_speed()
	check(not game.busy and game.store.booster_count("row_beam") == stock and game.speed == speed, "Intro rejects gameplay inputs without spending stock")
	for i in 35: game._process(.1)
	check(game.heist_intro.phase() == "conversion", "Ten beams enter the conversion phase")
	check(game.queue_remaining == before_timers and game.puzzle.board == before_board, "Conversion changes neither timers nor puzzle cells")
	check(is_zero_approx(game.depth_view.actors.modulate.a), "Cube drones remain hidden during conversion")
	var age: float = game.heist_intro.elapsed
	game._show_modal("pause")
	game._process(.1)
	check(game.heist_intro.elapsed == age, "Pause freezes the cinematic")
	game._close_modal()
	game.app_suspended = true
	game._process(.1)
	check(game.heist_intro.elapsed == age, "Background suspension freezes the cinematic")
	game.app_suspended = false
	var checkpoint = Checkpoint.new().capture(game)
	for i in 16: game._process(.1)
	check(intro.phase() == "return" and intro.scouts_outside(intro.elapsed) == 10, "Scouts start returning after beams stop")
	check(intro.carrier_position(intro.elapsed) == intro.carrier_position(intro.RELEASE_START), "Carrier waits in the queue area for its scouts")
	for i in 12: game._process(.1)
	check(intro.scouts_outside(intro.elapsed) == 0, "All ten scouts enter the hatch before carrier departure")
	check(is_zero_approx(game.depth_view.actors.modulate.a), "Cube queues stay hidden during collection and departure")
	for i in 23: game._process(.1)
	check(not game.intro_active() and is_equal_approx(game.depth_view.actors.modulate.a, 1.0), "Completion removes overlay and reveals queues")
	check(game.puzzle.board == before_board, "No pixels are collected by the intro")
	game._resume_heist(checkpoint)
	check(not game.intro_active(), "Restoring a saved heist bypasses the intro")
	game._start_level(5)
	var live_timer: Array = game.queue_remaining.duplicate()
	for i in 25: game._process(.1)
	check(float(live_timer[0]) > 0 and game.queue_remaining == live_timer, "Nonzero timed queues are frozen throughout the intro")
	game.reduced_motion = true
	game._process(.1)
	check(game.heist_intro.reduced, "Enabling reduced motion mid-intro takes effect")
	game._start_level(0)
	check(game.heist_intro.reduced, "Reduced motion uses a short crossfade")
	for i in 15: game._process(.1)
	check(not game.intro_active() and is_equal_approx(game.depth_view.actors.modulate.a, 1.0), "Reduced motion completes with fully visible queues")
	game.reduced_motion = false
	game._start_level(0)
	game._show_lobby()
	check(not game.intro_active(), "Leaving the heist discards its cinematic")
	check(game.HeistIntro.artwork_texture("unknown-work") == null, "Missing originals cannot substitute another painting")
	Fixture.cleanup(game)
	game.queue_free()
	await process_frame
	print("CHECKS: %d | FAILURES: %d" % [checks, failures])
	quit(1 if failures else 0)
