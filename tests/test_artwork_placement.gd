extends SceneTree
const Fixture = preload("res://tests/fixture.gd")
const Originals = preload("res://scripts/ui/heist_intro.gd")
const ArtView = preload("res://scripts/ui/museum_art.gd")
var checks := 0
var failures := 0
func check(ok: bool, label: String) -> void:
	checks += 1
	if not ok: failures += 1; printerr("FAIL: ", label)
func _initialize() -> void: call_deferred("run")
func run() -> void:
	var game = Fixture.create_game(); root.add_child(game); await process_frame
	game.set_process(false)
	var ids := {}
	for floor_number in range(1,11):
		for slot in game.campaign.stage_slots(floor_number):
			var id: String = slot.art_id
			check(not id.is_empty() and not ids.has(id),"Unique assigned original")
			ids[id] = true
			check(game.campaign.level_number(id)==int(slot.level),"Assignment retains level number")
			check(Originals.artwork_texture(id)!=null,"Original image loads: "+id)
			if int(slot.level)<=15:
				check(game.campaign.order()[int(slot.level)-1]==id,"Legacy level order preserved")
			else:
				check(game.level_for(id).is_empty() and not game.campaign.order().has(id),"Original does not create a puzzle")
				check(game.art_title(id)!=id,"Original has a readable English title")
	check(ids.size()==100 and game.levels.size()==15,"100 originals, 15 unchanged authored puzzles")
	var id: String = game.campaign.stage_slots(10)[0].art_id
	var before: Dictionary = game.store.state.duplicate(true)
	game._show_gallery("paintings")
	game.screen_view.floor_number=10; game.screen_view.refresh()
	game.screen_view._toggle_pixels()
	var art := ArtView.new(); root.add_child(art)
	art.setup(game,id,true,Vector2(300,300),false)
	check(art.get_child(0) is TextureRect,"Unproduced pixel mode retains the original image")
	check((art.get_child(0) as TextureRect).texture!=null,"Fallback preview is not blank")
	game.open_painting(id)
	check(game.modal_kind=="painting","Assigned future original can be inspected")
	check(game.store.state==before,"Browsing original never grants ownership or changes progress")
	check(not game.store.toggle_collection(id),"Future original cannot enter owned collection")
	game._close_modal(); game.open_painting("unknown_artwork")
	check(game.modal_kind.is_empty(),"Unknown original is rejected")
	art.queue_free(); Fixture.cleanup(game); game.queue_free(); await process_frame
	print("ARTWORK PLACEMENT CHECKS: %d | FAILURES: %d" % [checks,failures])
	quit(1 if failures else 0)
