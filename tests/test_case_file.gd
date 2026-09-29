extends SceneTree
const Fixture=preload("res://tests/fixture.gd")
const Catalog=preload("res://scripts/services/case_file_catalog.gd")
var checks:=0
var failures:=0
func check(ok:bool,label:String)->void:
	checks+=1
	if not ok:failures+=1;printerr("FAIL: ",label)
func _initialize()->void:call_deferred("run")
func run()->void:
	var game=Fixture.create_game();root.add_child(game);await process_frame;game.set_process(false)
	var test_time:int=game.store.now();game.store.clock=func():return test_time
	game.store.regenerate()
	var rows:=Catalog.stages(game)
	check(rows.size()==10 and Catalog.SCENES.size()==1,"Ten stable stage IDs, only Stage 1 art authored")
	check(rows[0].scenes.size()==1 and rows[0].scenes[0].kind=="Opening","Current case exposes opening only")
	for i in range(1,10):check(rows[i].scenes.is_empty(),"No placeholder story exposed for future stage %d"%(i+1))
	for panel in Catalog.SCENES.stage_first_commission.values():
		check(ResourceLoader.exists(panel.image) and panel.bubbles.size()==2,"Each Stage 1 scene has real art and two lines")
		for bubble in panel.bubbles:check(str(bubble.text).split(" ").size()<=8,"Short mobile dialogue: "+bubble.text)
	# First-launch scene is the same art as the archive; continuing starts the heist.
	game._show_story(0)
	check(game.screen_view.stage_scene_mode and game.screen_view.get_node("StageScene").panel==rows[0].scenes[0],"Live opening uses the shared illustrated scene")
	check(game.screen_view.get_node("StageScene/Next").text=="Start Heist","Opening has one clear heist action")
	game.screen_view._advance()
	check(game.screen=="play" and game.store.state.story.opening,"Opening continues to play and uses the existing seen flag")
	game._show_lobby()
	var initial:Dictionary=game.store.state.duplicate(true)
	game.screen_view.get_node("CaseFile").pressed.emit()
	var story=game.screen_view;var view=story.archive_view
	check(game.screen=="story" and view.get_node("Scroll/Rows").get_child_count()==10,"Case File stays inside S4")
	view.open_stage(2);check(view.mode=="directory","Unauthored stage does not open fake scenes")
	view.open_stage(1)
	check(view.mode=="reader" and not view.has_node("Scroll") and view.has_node("Reader/Scene/Artwork"),"Card opens art directly without text report page")
	check(view.get_node("Reader/Previous").disabled and view.get_node("Reader/Next").text=="Back to cases","Active case cannot reveal an unfinished finale")
	view.previous_scene();check(view.scene_index==0,"Previous cannot underflow")
	view.next_scene();check(view.mode=="directory","Opening-only replay returns to directory")
	story._choose("open_inventory");story._open_chest();story._finish_stage_scene()
	check(game.store.state==initial,"Archive cannot mutate story, ending or rewards")
	var esc:=InputEventKey.new();esc.keycode=KEY_ESCAPE;esc.pressed=true
	view.open_stage(1);game._unhandled_key_input(esc)
	check(view.mode=="directory","Escape from image returns to cases")
	game._unhandled_key_input(esc);check(game.screen=="lobby" and game.store.state==initial,"Escape from cases returns Home without writes")
	for id in game.campaign.order().slice(0,9):game.store.record_win(id,"",3)
	game.store.mark_story("first_commission")
	check(Catalog.stages(game)[0].scenes.size()==1,"Nine artworks and midway report still hide finale")
	var tenth:String=game.campaign.order()[9]
	game.store.record_win(tenth,"",3)
	rows=Catalog.stages(game)
	check(rows[0].completed and rows[0].scenes.size()==2,"Tenth unique artwork unlocks Opening and Finale without save migration")
	check(rows[0].scenes[1].kind=="Finale" and not game.store.state.story.seen.has("false_owners"),"Completed legacy save can replay finale even without old seen flag")
	check(rows[1].unlocked and rows[1].scenes.is_empty(),"Stage 2 progress is preserved while its new scenes remain unauthored")
	game.last_win={"art_id":tenth,"first":true};game._complete_continue()
	check(game.screen=="story" and game.screen_view.stage_scene_mode and game.screen_view.get_node("StageScene").panel.kind=="Finale","Level 10 Continue opens the illustrated ending directly")
	check(not game.store.state.chests.chapter_claimed.has("false_owners"),"Showing the ending alone does not claim rewards")
	var ending=game.screen_view
	var before_gold:int=game.store.state.gold
	ending._advance()
	check(game.screen=="lobby" and game.modal_kind=="reward" and game.store.state.story.seen.has("false_owners"),"Ending returns Home, marks existing story ID and shows reward receipt")
	check(game.store.state.gold==before_gold+int(game.store.rules.chapter_chest.gold),"Existing stage chest amount is preserved")
	var awarded:Dictionary=game.store.state.duplicate(true)
	ending._finish_stage_scene();check(game.store.state==awarded,"Double activation cannot duplicate stage rewards")
	game._close_modal()
	game.last_win={"art_id":tenth,"first":false};game._complete_continue()
	check(game.screen=="lobby","Replaying Level 10 does not automatically replay the ending")
	initial=game.store.state.duplicate(true)
	game.screen_view.get_node("CaseFile").pressed.emit();view=game.screen_view.archive_view
	view.open_stage(1)
	check(view.get_node("Reader/Next").text=="Next scene","Completed case offers its ending after opening")
	view.next_scene();check(view.scene_index==1 and not view.get_node("Reader/Previous").disabled,"Completed case opens the ending with Previous available")
	view.previous_scene();check(view.scene_index==0,"Previous returns to opening")
	view.next_scene()
	for extent in [Vector2(720,1280),Vector2(720,1558)]:
		view.set_anchors_and_offsets_preset(Control.PRESET_TOP_LEFT);view.size=extent;view._render();await process_frame
		var reader=view.get_node("Reader")
		check(reader.get_node("Scene").get_rect().end.y+12<=reader.get_node("Next").position.y,"Scene clears navigation at %d"%extent.y)
		check(not reader.has_node("Dialogue1") and reader.has_node("Scene/Artwork/SpeechBubbles/Dialogue1"),"Dialogue lives on the artwork, with no separate text area")
		check(reader.get_node("Scene/Artwork").stretch_mode==TextureRect.STRETCH_KEEP_ASPECT_CENTERED,"Story artwork is never cropped")
		check(reader.get_node("Next").get_rect().end.y<=extent.y-24,"Bottom action remains inside viewport")
	view.next_scene();check(view.mode=="directory" and game.store.state==initial,"Opening/finale replay is fully read-only")
	Fixture.cleanup(game);game.queue_free();await process_frame
	print("CASE FILE CHECKS: %d | FAILURES: %d"%[checks,failures]);quit(1 if failures else 0)
