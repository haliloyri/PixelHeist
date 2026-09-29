extends SceneTree
const Fixture = preload("res://tests/fixture.gd")
var checks := 0
var failures := 0

func check(ok: bool, message: String) -> void:
	checks += 1
	if not ok:
		failures += 1
		printerr("FAIL: ", message)

func _initialize() -> void: call_deferred("run")

func check_layout(game, label: String) -> void:
	var frame: Rect2 = game.frame_rect()
	var title: Label = game.screen_view.get_node("ArtifactTitle")
	var progress: Label = game.screen_view.get_node("ProgressLabel")
	var bar: Control = game.screen_view.get_node("ProgressBacking")
	check(title.text == game.art_title(game.current_level().art_id), label + " shows its own artwork name")
	check(title.position.y < frame.position.y and title.position.y + title.size.y > frame.position.y, label + " title sits on the top frame")
	check(progress.position.y + progress.size.y <= frame.position.y - 8.0, label + " progress count clears the frame")
	check(bar.position.y < progress.position.y and bar.position.y + bar.size.y <= progress.position.y, label + " slim bar sits above its count")
	check(frame.position.y >= game.HEIST_FRAME_TOP_MIN, label + " frame clears the shared HUD")
	check(game.frame_gaps.size() == 2 and float(game.frame_gaps[0]) < frame.get_center().x and float(game.frame_gaps[1]) > frame.get_center().x, label + " keeps two bottom passages")

func run() -> void:
	var game = Fixture.create_game()
	root.add_child(game)
	await process_frame
	game.set_process(false)
	game.app_suspended = false
	game.store.apply(func(s): s.story.opening = true; return true)
	for index in game.levels.size():
		game._start_level(index)
		check_layout(game, str(game.current_level().art_id))
	var current: Dictionary = game.levels[1].duplicate(true)
	var old: Dictionary = current.previous_versions[0].duplicate(true)
	game.levels[1] = old
	game._start_level(1)
	var job: Dictionary = game.heist_checkpoint.capture(game)
	game.levels[1] = current
	game._resume_heist(job)
	check(game.current_level().cells == old.cells, "Legacy Sapphire Cup board survives resume")
	check_layout(game, "Resumed legacy Sapphire Cup")
	Fixture.cleanup(game)
	game.queue_free()
	await process_frame
	print("SHARED HEIST HUD CHECKS: %d | FAILURES: %d" % [checks, failures])
	quit(1 if failures else 0)
