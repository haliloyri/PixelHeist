extends SceneTree
const Fixture = preload("res://tests/fixture.gd")
const Gait = preload("res://scripts/ui/ant_gait.gd")
const FX = preload("res://scripts/ui/row_beam_fx.gd")
const Checkpoint = preload("res://scripts/services/heist_checkpoint.gd")
var checks:=0
var failures:=0
func check(ok:bool,label:String)->void:
	checks+=1
	if not ok: failures+=1;printerr("FAIL: ",label)
func _initialize()->void:call_deferred("run")
func run()->void:
	var game=Fixture.create_game()
	root.add_child(game)
	await process_frame
	game.set_process(false)
	game.store.apply(func(s):s.story.opening=true;s.boosters.row_beam=100;return true)
	game._start_level(8)
	var base:={"position":Vector2(100,650),"path":[Vector2(100,650),Vector2(2000,650)],"segment":1,"phase":0,"dwell":0.0,"tile_size":12.0,"walk_distance":0.0}
	var normal:Dictionary=base.duplicate(true)
	var fast:Dictionary=base.duplicate(true)
	game.speed=1
	game._advance_drone(normal,.1*game.ant_tempo())
	game.speed=2
	game._advance_drone(fast,.1*game.ant_tempo())
	check(is_equal_approx(fast.walk_distance,normal.walk_distance*2),"2x advances twice the actual route distance")
	check(is_equal_approx(Gait.phase(fast.walk_distance,32),Gait.phase(normal.walk_distance,32)*2),"2x gait advances in lockstep with travel")
	check(is_equal_approx(normal.position.distance_to(base.position),normal.walk_distance),"Gait measures real movement, not elapsed wall time")
	var stopped:Dictionary=normal.duplicate(true)
	stopped.dwell=.5
	game._advance_drone(stopped,.1)
	check(stopped.walk_distance==normal.walk_distance,"Pickup dwell does not walk in place")
	var gated:Dictionary=base.duplicate(true)
	gated.gate=1;gated.gap=0
	game.gap_open=[0.0,0.0]
	game._advance_drone(gated,.1)
	check(gated.walk_distance==0,"A closed frame gate freezes the feet")
	var a:=Gait.leg(-1,0,0,32)
	var b:=Gait.leg(-1,0,PI,32)
	check(a[2].distance_to(b[2])>5,"Feet have a clearly visible alternating stride")
	check(Gait.leg(-1,0,PI*.5,32)[2].y!=Gait.leg(1,0,PI*.5,32)[2].y,"Opposite tripods do not step together")
	var before:Dictionary=game.puzzle.snapshot()
	var stock:int=game.store.booster_count("row_beam")
	game._use_booster("row_beam")
	check(game.beam_effects.size()==before.remaining-game.puzzle.remaining,"Every removed pixel creates one visible transfer")
	check(game.store.booster_count("row_beam")==stock-1,"Beam stock commits once before the animation")
	var remaining:int=game.puzzle.remaining
	var effect:Dictionary=game.beam_effects[0]
	var start:Vector2=game.board_art.visual_cell_position(effect.cell)
	var target:Vector2=game.beam_target_position(effect.target)
	var initial:=FX.pose(effect,start,target)
	check(initial.position.is_equal_approx(start) and initial.alpha==1,"Removed pixels first remain visible at the cleared row")
	check(target.y>start.y,"Transfer targets the boxes below the painting")
	game.modal_kind="pause"
	game._process(.1)
	check(effect.age==0,"Pause freezes Row Beam effects")
	game.modal_kind=""
	game.app_suspended=true
	game._process(.1)
	check(effect.age==0,"App suspension freezes effects")
	game.app_suspended=false
	for i in 9:game._process(.1)
	var moving:=FX.pose(effect,start,target)
	check(moving.position.y>start.y+50 and moving.position.y<target.y,"Pixels move toward the drone boxes")
	check(moving.alpha<1 and moving.scale<1,"Pixels shrink and fade during travel")
	check(Checkpoint.new().validate(Checkpoint.new().capture(game),game.levels).is_empty(),"In-effect checkpoint remains balanced")
	for i in 15:game._process(.1)
	check(game.beam_effects.is_empty(),"Transfer effects clean themselves up")
	check(game.puzzle.remaining==remaining and game.store.booster_count("row_beam")==stock-1,"Visual completion cannot remove or charge twice")
	game.reduced_motion=true
	game._use_booster("row_beam")
	effect=game.beam_effects[0]
	start=game.board_art.visual_cell_position(effect.cell)
	effect.age=.2
	check(FX.pose(effect,start,target).position==start,"Reduced motion uses a local dissolve")
	game._start_level(0)
	game.reduced_motion=false
	var guard:=0
	while game.puzzle.remaining>0 and guard<40:
		game._use_booster("row_beam");guard+=1
	check(game.puzzle.remaining==0 and game.screen=="play" and not game.beam_effects.is_empty(),"Final-row visuals are visible before the reward screen")
	var job:Dictionary=Checkpoint.new().capture(game)
	check(Checkpoint.new().validate(job,game.levels).is_empty(),"Final-row commit is a valid resumable win")
	for i in 25:game._process(.1)
	check(game.screen=="complete","Final-row animation ends with the normal reward screen")
	var gold:int=game.store.state.gold
	for i in 10:game._process(.1)
	check(int(game.store.state.gold)==gold,"Waiting after the effect does not duplicate rewards")
	game._start_level(8)
	check(game.beam_effects.is_empty(),"Starting a new heist clears transient effects")
	Fixture.cleanup(game)
	game.queue_free()
	await process_frame
	print("MOTION CHECKS: %d | FAILURES: %d" %[checks,failures])
	quit(1 if failures else 0)
