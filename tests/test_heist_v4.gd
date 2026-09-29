extends SceneTree
## Approved gameplay layout, capacity conservation and pre-v4 save compatibility.
const Fixture = preload("res://tests/fixture.gd")
const Checkpoint = preload("res://scripts/services/heist_checkpoint.gd")
const Store = preload("res://scripts/services/progress_store.gd")
const Layout = preload("res://scripts/ui/queue_layout.gd")
var checks := 0
var failures := 0
func check(ok: bool,label: String) -> void:
	checks += 1
	if not ok:
		failures += 1
		printerr("FAIL: ",label)
func _initialize() -> void: call_deferred("run")
func run() -> void:
	var game = Fixture.create_game()
	root.add_child(game)
	await process_frame
	game.set_process(false)
	game.store.apply(func(s): s.story.opening = true; s.boosters.row_beam = 20; s.boosters.zap = 5; return true)
	var validator := Checkpoint.new()
	for level in [0,8,10]:
		game._start_level(level)
		check(game.puzzle.dock_count() == 5,"Every new heist starts with five shared docks")
		for i in 3:
			var before: int = game.puzzle.remaining
			var stock: int = game.store.booster_count("row_beam")
			var row: int = game.puzzle.beam_row()
			game._use_booster("row_beam")
			check(game.puzzle.remaining < before and game.puzzle.beam_row() < row,"Beam removes exactly the lowest occupied row")
			check(game.store.booster_count("row_beam") == stock-1,"Successful beam spends exactly one stock")
			check(validator.validate(validator.capture(game),game.levels).is_empty(),"Beam preserves checkpoint pixel/capacity balance")
		check(game.queue_buttons.size() == game.puzzle.slot_count,"All authored lanes keep their click targets")
		var shown := {}
		for page in ceili(game.puzzle.slot_count/3.0):
			game.queue_page = page
			game._refresh_play_hud()
			var visible := 0
			for c in game.puzzle.slot_count:
				if game.queue_buttons[c].visible:
					visible += 1
					shown[c] = true
			check(visible <= 3,"Queue page contains at most three columns")
		check(shown.size() == game.puzzle.slot_count,"Paging retains access to every authored lane")
	game._start_level(8)
	for c in game.puzzle.slot_count:
		if game.puzzle.can_deploy(c): game._deploy(c)
	for i in 50:
		game._process(.04)
		if not game.puzzle.can_beam(): break
	check(not game.puzzle.reservations.is_empty(),"Real ant flight reserves a pixel")
	if not game.puzzle.can_beam():
		var stock: int = game.store.booster_count("row_beam")
		var before: int = game.puzzle.remaining
		game._use_booster("row_beam")
		check(game.store.booster_count("row_beam") == stock and game.puzzle.remaining == before,"Busy target row neither clears nor charges")
	var job: Dictionary = validator.capture(game)
	check(validator.validate(job,game.levels).is_empty(),"In-flight checkpoint is valid")
	var old_origin: Vector2 = game.flights[0].origin if not game.flights.is_empty() else Vector2.ZERO
	game.size = Vector2(720,1558)
	game._resize_heist()
	check(game.dock_position(0).y == 1030,"Tall screen anchors active row to footer")
	check(is_equal_approx(game.queue_buttons[0].position.y,Layout.front(0,3).position.y+278),"Tall screen keeps hit target over visual carrier")
	check(game.depth_view.actors.size.y == 1456,"Tall screen clips queue immediately above footer")
	if not game.flights.is_empty(): check(is_equal_approx(game.flights[0].origin.y-old_origin.y,278),"Live ant origins follow resized docks")
	check(validator.validate(validator.capture(game),game.levels).is_empty(),"Resize preserves in-flight reservations and checkpoint")
	game.size = Vector2(720,1280)
	game._resize_heist()
	game._resume_heist(job)
	check(game.puzzle.snapshot() == job.puzzle,"Resume preserves the exact logical puzzle")
	check(validator.validate(validator.capture(game),game.levels).is_empty(),"Resumed ants remain valid")
	# Old three-dock checkpoint and four-stock save remain usable without resetting progress.
	game._start_level(0)
	game.puzzle.active.resize(3)
	game.puzzle.base_docks = 3
	job = validator.capture(game)
	job.puzzle.erase("base_docks")
	job.motion.erase("layout")
	check(validator.validate(job,game.levels).is_empty(),"Pre-v4 three-dock checkpoint is accepted")
	game._resume_heist(job)
	check(game.puzzle.dock_count() == 3 and game.puzzle.extra_docks() == 0,"Legacy ongoing heist retains its existing capacity")
	check(validator.validate(validator.capture(game),game.levels).is_empty(),"Legacy resume can be saved again")
	var prior: Dictionary = game.store.state.duplicate(true)
	prior.boosters.erase("row_beam")
	check(game.store.commit(prior) == OK,"Existing four-stock save remains valid")
	var reopened := Store.new()
	reopened.open(game.save_path)
	check(not reopened.read_only and reopened.booster_count("row_beam") == 0,"Old save gains zero Row Beam stock without locking")
	check(reopened.state.gold == prior.gold and reopened.state.completed == prior.completed and reopened.state.boosters.zap == prior.boosters.zap,"Migration retains wallet, completion and owned boosters")
	for count in [5,6,7]:
		check(Layout.cube_size(count).x < Layout.spacing(count),"Extra docks keep carriers separate")
	check(Layout.row(0,3,2).y+Layout.cube_size(5).y*.5 < 1178,"Three complete waiting rows fit")
	check(1178-(Layout.row(0,3,3).y-Layout.cube_size(5).y*.5) < 35,"Only the fourth row's top is exposed")
	Fixture.cleanup(game)
	game.queue_free()
	await process_frame
	print("HEIST V4 CHECKS: %d | FAILURES: %d" % [checks,failures])
	quit(1 if failures else 0)
