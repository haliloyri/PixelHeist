extends SceneTree
const Fixture=preload("res://tests/fixture.gd")
const Store=preload("res://scripts/services/progress_store.gd")
var checks:=0
var failures:=0
func check(ok:bool, message:String)->void:
	checks+=1
	if not ok:failures+=1;printerr("FAIL: ",message)
func _initialize()->void:call_deferred("run")
func run()->void:
	var game=Fixture.create_game();root.add_child(game);await process_frame
	game.set_process(false);game.app_suspended=false
	game.store.apply(func(s):s.story.opening=true;return true)
	game._start_level(0)
	var timestamp: Array=[game.store.now()]
	game.store.clock=func()->int:return int(timestamp[0])
	check(game.speed==1 and game.store.speed3_remaining()==0,"New save starts at 1X without paid time")
	game._toggle_speed()
	check(game.speed==2 and game.store.state.gold==200,"2X remains free")
	game._toggle_speed()
	check(game.speed==1,"Free button switches back to 1X")
	game._select_speed3()
	check(game.modal_kind=="get_booster" and game.store.state.gold==200,"3X presents the price before spending")
	check(game.screen_view.get_node("SpeedButton").multiplier==1 and game.screen_view.get_node("Speed3Button").multiplier==3,"Free and timed speeds have distinct controls")
	game._close_modal()
	game.store.apply(func(s):s.gold=600;return true)
	game._select_speed3()
	game._buy_speed3()
	check(game.modal_kind.is_empty() and game.speed==3,"Paid activation enters 3X")
	check(game.store.state.gold==300 and game.store.speed3_remaining()==300,"Exactly 300 gold buys five minutes")
	var job:Dictionary=game.store.state.session.duplicate(true)
	check(game.heist_checkpoint.validate(job,game.levels).is_empty() and job.motion.speed==3,"Paid time and 3X checkpoint commit together")
	game._buy_speed3()
	check(game.store.state.gold==300,"Repeated activation never charges twice")
	game._toggle_speed()
	check(game.speed==1 and game.store.speed3_remaining()==300,"Leaving 3X preserves the purchased time")
	game._select_speed3()
	check(game.speed==3 and game.store.state.gold==300,"Purchased 3X can be reselected without another charge")
	timestamp[0]+=299
	game._process(.1)
	check(game.speed==3 and game.store.speed3_remaining()==1,"Timer survives nearly five minutes and updates the chip")
	timestamp[0]+=1
	game._process(.1)
	check(game.speed==2 and game.store.speed3_remaining()==0,"3X expiry falls back to free 2X")
	check(game.store.state.session.motion.speed==2,"Expired mode is saved without recharging")
	var reopened:=Store.new();reopened.open(game.save_path)
	check(reopened.state.gold==300 and reopened.state.speed3_until==timestamp[0],"Paid entitlement and wallet survive reopening")
	game._resume_heist(job)
	check(game.speed==2,"An expired 3X checkpoint resumes safely at 2X")
	# Three times the normal ant travel distance at the same real time.
	var base:={"position":Vector2(100,600),"path":[Vector2(100,600),Vector2(2000,600)],"segment":1,"phase":0,"dwell":0.0,"walk_distance":0.0}
	var one:Dictionary=base.duplicate(true)
	var three:Dictionary=base.duplicate(true)
	game.speed=1;game._advance_drone(one,.1*game.ant_tempo())
	game.speed=3;game._advance_drone(three,.1*game.ant_tempo())
	check(is_equal_approx(three.walk_distance,one.walk_distance*3),"3X changes ant travel only")
	Fixture.cleanup(game);game.queue_free();await process_frame
	print("SPEED 3 CHECKS: %d | FAILURES: %d"%[checks,failures]);quit(1 if failures else 0)
