extends SceneTree
## r13 boosters, Out of Space and dock geometry (design section 3).
const Puzzle = preload("res://scripts/core/puzzle_state.gd")
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

func tiny(entry: String = "all") -> Dictionary:
	# Two colours; colour 1 sits under a ring of colour 0 (sealed until 0 clears).
	var cells := [0, 0, 0, 0, 1, 0, 0, 0, 0]
	return {"width": 3, "height": 3, "cells": cells, "entry_mode": entry, "palette": ["#aa5500", "#2288ff", "#777777"],
		"lanes": [[{"color": 1, "amount": 1}], [{"color": 1, "amount": 1}, {"color": 0, "amount": 8}], [{"color": 2, "amount": 3, "decoy": true, "mystery": true}]]}

func run() -> void:
	var p = Puzzle.new()
	p.setup(tiny())
	check(p.dock_count() == 3 and p.extra_docks() == 0, "Three docks at start")
	check(p.add_dock() and p.dock_count() == 4, "Extra Dock adds a fourth shared dock")
	check(p.add_dock() and not p.add_dock() and p.extra_docks() == 2, "At most two extra docks")
	var snap: Dictionary = p.snapshot()
	var q = Puzzle.new()
	q.setup(tiny())
	q.restore(snap)
	check(q.dock_count() == 5, "Extra docks survive snapshot/restore")

	# Jam: both sealed colour-1 carriers fill docks while colour 0 waits behind.
	p = Puzzle.new()
	p.setup(tiny())
	check(p.deploy(0) and p.deploy(1), "Two sealed carriers deploy")
	check(p.status() == "ready" or p.status() == "waiting", "A free dock remains")
	check(not p.can_deploy(2), "Decoy packets cannot be selected")
	p.lanes[2] = [{"color": 1, "amount": 1}]
	p.art_colors[1] = true
	p.remaining += 0
	check(p.deploy(2) and p.jammed(), "All docks hold waiting carriers: jammed")
	check(p.can_zap(0), "An idle carrier can be zapped")
	var lane_before: int = p.lanes[0].size()
	check(p.zap(0) and p.active[0].is_empty() and p.lanes[0].size() == lane_before + 1, "Zap returns the carrier to the back of its own queue")
	check(p.lanes[0].back().color == 1 and int(p.lanes[0].back().amount) == 1, "Zapped packet keeps colour and remaining capacity")
	check(not p.jammed(), "Zap frees a dock")
	check(p.add_dock() and p.deploy(1) and not p.jammed(), "Extra Dock relieves a jam")

	# Scout Fly.
	p = Puzzle.new()
	p.setup(tiny())
	check(p.has_mystery(), "Mystery packet present")
	check(p.reveal_mysteries() == 1 and not p.has_mystery(), "Scout Fly reveals every ? packet")

	# Master Key on a bottom-entry board.
	p = Puzzle.new()
	var open_board := tiny()
	open_board.cells = [0, -1, 0, 0, 0, 0, 0, 0, 0]
	open_board.lanes = [[{"color": 0, "amount": 8}], [], []]
	open_board.entry_mode = "bottom"
	p.setup(open_board)
	var bottom_access: int = p.accessible_cells().size()
	check(p.can_use_key() and p.arm_key() and not p.can_use_key(), "Master Key arms once")
	check(p.deploy(0) and p.entry_mode == "all", "Keyed carrier opens every side")
	check(p.accessible_cells().size() > bottom_access, "Every side adds reachable pixels")
	while not p.step().is_empty(): pass
	check(p.remaining == 0 and p.entry_mode == "bottom" and p.key_order == -1, "Entry rule returns when the keyed carrier finishes")
	p.setup(tiny())
	check(not p.can_use_key(), "Master Key is not offered on open boards")

	# Controller: boosters spend stock, Continue, stars.
	var game = Fixture.create_game()
	root.add_child(game)
	await process_frame
	game.set_process(false)
	game.store.apply(func(s):
		for id in s.boosters: s.boosters[id] = 2
		s.story.opening = true
		return true)
	game._start_level(0)
	check(game.screen == "play" and game.tool_buttons.size() == 3, "Heist shows three compact powers")
	check(not game.screen_view.get_node("UndoButton").visible and not game.screen_view.get_node("SoundButton").visible, "Undo and Sound are gone from the heist")
	game._use_booster("extra_dock")
	check(game.puzzle.dock_count() == 6 and game.store.booster_count("extra_dock") == 1 and game.boosters_used == 1, "Extra Dock spends one and adds a dock")
	check(game.depth_view.pads.size() == 6, "Six landing plates are drawn")
	game._use_booster("scout_fly")
	check(game.store.booster_count("scout_fly") == 1 and not game.puzzle.has_mystery() and game.boosters_used == 2, "Scout Fly reveals Level 1's ? packet and spends one")
	game._use_booster("master_key")
	check(game.store.booster_count("master_key") == 1, "Legacy Master Key still works on the now bottom-entry board")
	game.store.apply(func(s): s.boosters.zap = 0; return true)
	game._use_booster("zap")
	check(game.modal_kind == "get_booster", "Zero stock opens Get Booster")
	game._close_modal()
	game.store.apply(func(s): s.gold = 1000; return true)
	game._show_modal("out_of_space")
	game._continue_gold()
	check(game.puzzle.dock_count() == 7 and int(game.store.state.gold) == 100 and game.continues_used == 1, "Continue +1 Dock costs 900")
	check(game.modal_kind == "", "Continue closes the pop-up")
	var job: Dictionary = Checkpoint.new().capture(game)
	check(Checkpoint.new().validate(job, game.levels).is_empty(), "Checkpoint with boosters validates")
	check(int(job.used) == 3 and int(job.continues) == 1, "Checkpoint keeps booster/continue counters")
	game._toggle_speed()
	check(game.speed == 2, "Free 2x toggle")
	game._toggle_speed()
	check(game.speed == 1, "Back to 1x")
	# Retry costs energy and restarts.
	var energy: int = int(game.store.state.energy)
	game._retry()
	check(int(game.store.state.energy) == energy - 1 and game.puzzle.dock_count() == 5 and game.boosters_used == 0, "Retry costs one energy and restarts clean")
	Fixture.cleanup(game)
	game.queue_free()
	await process_frame
	print("R13 BOOSTER CHECKS: %d | FAILURES: %d" % [checks, failures])
	quit(1 if failures > 0 else 0)
