extends SceneTree
const Fixture = preload("res://tests/fixture.gd")
const Pixels = preload("res://scripts/ui/artwork_pixels.gd")
const Packets = preload("res://scripts/core/packet_queues.gd")
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
	var current: Dictionary = game.levels[1].duplicate(true)
	var reference: Dictionary = game.levels[10]
	var pitch: float = minf(436.0 / float(reference.width), 290.0 / float(reference.height))
	check(current.art_id == "sapphire_cup" and current.width == 22 and current.height == 22, "Sapphire Cup keeps its ID and square source proportions")
	check(current.cells.size() == 484 and current.palette.size() == 5, "Source board has 484 five-color playable cubes")
	check(current.pixel_style == "raised_blocks" and not current.palette.has(current.board_backing), "Cubes are raised over a distinct cool backing")
	check(is_equal_approx(float(current.heist_cell_pitch), pitch), "Sapphire Cup matches the first artwork's screen-cell pitch")
	check(game.level_for("sapphire_cup").cells == current.cells, "Museum and heist use the same current board")
	for color in 5:
		var found := false
		for cell in current.cells:
			if int(cell) == color:
				found = true
				break
		check(found, "Every playable color appears in the artwork")
	for cell in [0, 44, 116, 220, 346, 460]:
		check(Pixels.color_at(current, cell) == Color(current.palette[int(current.cells[cell])]), "Cube color matches its carrier palette")
	game._start_level(1)
	check(game.puzzle.total == 484 and game.puzzle.dock_count() == 5, "Fresh heist uses the new board and shared docks")
	check(is_equal_approx(game.depth_view.tile_size, pitch * .01), "Gameplay 3D cubes retain the reference pitch")
	var job: Dictionary = game.heist_checkpoint.capture(game)
	check(game.heist_checkpoint.validate(job, game.levels).is_empty(), "Current checkpoint validates")
	game._resume_heist(job)
	check(game.puzzle.snapshot() == job.puzzle, "Current heist resumes without moving pixels")
	for old in [current.previous_versions[0].duplicate(true), game.all_levels[1].duplicate(true)]:
		game.levels[1] = old
		game._start_level(1)
		game._deploy(0)
		for tick in 30: game._process(.05)
		job = game.heist_checkpoint.capture(game)
		game.levels[1] = current
		check(game.heist_checkpoint.validate(job, game.levels).is_empty(), "Previous in-flight Sapphire Cup board validates")
		check(not Packets.migrate(game.puzzle, current), "Old queue cannot migrate across different cells")
		var balance: Dictionary = game.store.state.duplicate(true)
		game._resume_heist(job)
		check(game.current_level().cells == old.cells and game.puzzle.board == job.puzzle.board, "Old board and collected pixels resume intact")
		check(game.flights.size() == job.motion.flights.size(), "In-flight ants resume intact")
		check(game.store.state == balance, "Resume does not alter wallet or progress")
	game._start_level(1)
	check(game.current_level().cells == current.cells, "Next fresh heist receives the new board")
	var simulated_seconds := 0.0
	for value in current.solution:
		var guard := 0
		while game.busy and guard < 10000 and game.screen == "play":
			game._process(.1)
			guard += 1
			simulated_seconds += .1
		if guard >= 10000:
			check(false, "Carrier route must settle")
			break
		check(game.puzzle.can_deploy(int(value)), "Authored packet can enter a shared dock")
		game._deploy(int(value))
		check(game.heist_checkpoint.validate(game.heist_checkpoint.capture(game), game.levels).is_empty(), "Active route preserves budgets")
	var guard := 0
	while game.screen == "play" and guard < 20000:
		game._process(.1)
		guard += 1
		simulated_seconds += .1
	check(game.screen == "complete" and game.puzzle.remaining == 0, "Full Sapphire Cup flight wins without boosters")
	check(game.store.state.completed.has("sapphire_cup") and game.store.state.session.is_empty(), "Win records the stable artwork ID and clears the session")
	print("SAPPHIRE CUP SIMULATED SECONDS: ", simulated_seconds)
	Fixture.cleanup(game)
	game.queue_free()
	await process_frame
	print("SAPPHIRE CUP PIXELS CHECKS: %d | FAILURES: %d" % [checks, failures])
	quit(1 if failures else 0)
