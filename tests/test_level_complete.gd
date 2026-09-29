extends SceneTree
const Fixture=preload("res://tests/fixture.gd")
var checks:=0
var failures:=0
func check(ok:bool,label:String)->void:
	checks+=1
	if not ok:failures+=1;printerr("FAIL: ",label)
func _initialize()->void:call_deferred("run")
func show_win(game,id:String,stars:int,crew:String="")->void:
	game.last_win=game.store.record_win(id,"",stars)
	game.last_win.merge({"art_id":id,"crew":crew,"double_used":false})
	game._show_complete();game.screen_view.set_process(false)
func run()->void:
	var game=Fixture.create_game();root.add_child(game);await process_frame;game.set_process(false)
	game.store.apply(func(s):s.story.opening=true;return true)
	game.reduced_motion=false
	seed(314);var expected:=randf();seed(314)
	show_win(game,"sun_seal",3)
	check(randf()==expected,"Cosmetic particles do not change global gameplay RNG")
	var view=game.screen_view
	var wallet:int=game.store.state.gold
	check(view.continue_button.visible and not view.continue_button.disabled,"Continue is available at the first animation frame")
	check(view.confetti.pieces.size()==84 and view.confetti.mouse_filter==Control.MOUSE_FILTER_IGNORE,"Confetti is bounded and does not intercept input")
	check(view.gold_label.text=="+40" and view.card.get_node("Bubble/Speaker").text=="Sprocket","Saved rewards and canonical speaker remain visible")
	check(not view.double_button.visible,"First win does not expose early rewarded ads")
	check(view.museum_button.visible and view.museum_button.size.x==608,"Single secondary action fills its shelf")
	view.advance_celebration(.3)
	check(view.stars[0].scale.x>view.stars[2].scale.x,"Earned stars enter in sequence")
	var age:float=view.celebration_age
	game.app_suspended=true;view._process(.5)
	check(view.celebration_age==age,"App suspension freezes the celebration")
	game.app_suspended=false;game.modal_kind="test";view._process(.5)
	check(view.celebration_age==age,"An overlay freezes the celebration")
	game.modal_kind="";view._process(.2)
	check(view.celebration_age>age,"Celebration resumes from the same time")
	view.advance_celebration(10)
	check(view.confetti.visible_piece_count()==0 and not view.is_processing(),"Particles and animation processing finish once")
	check(view.frame.scale==Vector2.ONE and view.portraits.position==view.portrait_origin,"Painting and portraits settle exactly")
	check(view.portraits.get_rect().end.y<view.card.get_node("ArtworkTitle").position.y,"Character silhouettes leave room for the artwork title")
	view.refresh(game.last_win)
	check(view.celebration_age==3.2 and game.store.state.gold==wallet,"Refresh does not replay the celebration or grant rewards")
	view.continue_button.pressed.emit()
	check(game.screen=="lobby","Continue returns ordinary wins to Safehouse")
	for id in game.campaign.order().slice(1,5):game.store.record_win(id,"",3)
	show_win(game,"moon_gate_mask",3,"bit")
	game.last_win.first=true;view=game.screen_view
	# First-time milestone gating is established when the screen is built.
	game._show_complete();view=game.screen_view;view.set_process(false)
	check(view.card.has_node("CrewCard") and not view.museum_button.visible,"New crew has its own card; first milestone cannot skip Story")
	check(view.card.get_node("CrewCard").get_rect().end.y<view.continue_button.position.y,"Crew card and action shelf do not overlap")
	view.continue_button.pressed.emit()
	check(game.screen=="story" and game.story_chapter==1,"Milestone Continue keeps the story route")
	game.reduced_motion=true
	show_win(game,"the_gleaners",1)
	view=game.screen_view
	check(view.confetti.pieces.is_empty() and not view.is_processing(),"Reduced motion has no confetti or animation loop")
	check(view.stars[0].filled and not view.stars[1].filled and not view.stars[2].filled,"One-star win does not display unearned filled stars")
	check(view.stars[0].scale==Vector2.ONE and view.portraits.modulate.a==1,"Reduced-motion celebration is complete immediately")
	show_win(game,"sun_seal",1);view=game.screen_view
	check(view.gold_label.text=="+10" and view.stars[2].filled,"Replay retains the reduced reward and previously earned best rating")
	for id in game.campaign.order():game.store.record_win(id,"",3)
	game.reduced_motion=false
	show_win(game,"sun_seal",3);view=game.screen_view
	check(view.double_button.visible and view.double_button.text.contains("Watch Ad"),"Eligible optional double-coins action explicitly names the ad")
	view.advance_celebration(1)
	var before:int=game.store.state.gold
	game._on_rewarded("double","cancelled","test-cancel")
	check(game.store.state.gold==before and view.double_button.visible,"Cancelled ad grants nothing and preserves the option")
	game._on_rewarded("double","rewarded","test-victory-double")
	check(game.store.state.gold==before+10 and view.gold_label.text=="+20" and not view.double_button.visible,"Rewarded ad updates exact amount and hides the used action")
	check(view.celebration_age==1 and view.museum_button.size.x==608,"Ad refresh does not replay effects and closes the empty button gap")
	game._on_rewarded("double","rewarded","test-victory-double")
	check(game.store.state.gold==before+10,"Duplicate ad callback cannot double the reward again")
	view.set_anchors_and_offsets_preset(Control.PRESET_TOP_LEFT)
	for extent in [Vector2(720,1280),Vector2(720,1558)]:
		view.size=extent;view._layout()
		check(view.card.get_rect().end.y<=extent.y-24 and view.card.position.y>=24,"Victory card fits portrait height %d"%extent.y)
		check(view.confetti.get_rect().end.y<view.continue_button.position.y,"Celebration never covers the action shelf")
	view.museum_button.pressed.emit()
	check(game.screen=="gallery" and game.screen_view.floor_number==1,"Museum action opens the winning artwork floor")
	Fixture.cleanup(game);game.queue_free();await process_frame
	print("LEVEL COMPLETE CHECKS: %d | FAILURES: %d"%[checks,failures]);quit(1 if failures else 0)
