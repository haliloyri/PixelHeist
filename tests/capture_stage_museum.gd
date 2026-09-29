extends SceneTree
const Fixture=preload("res://tests/fixture.gd")
var game
func _initialize()->void:call_deferred("run")
func shot(name:String)->void:
	for i in 4:await process_frame
	RenderingServer.force_draw(false)
	root.get_texture().get_image().save_png("res://artifacts/museum-"+name+".png")
func run()->void:
	game=Fixture.create_game();root.add_child(game);await process_frame
	game.set_process(false)
	game.store.apply(func(s):s.story.opening=true;return true)
	for id in game.campaign.order().slice(0,4):game.store.record_win(id,"",3)
	root.size=Vector2i(720,1280)
	game._show_gallery("paintings");await shot("locked-originals")
	game.screen_view._toggle_pixels();await shot("locked-pixels")
	for id in game.campaign.order().slice(4):game.store.record_win(id,"",3)
	for id in game.campaign.order().slice(0,10):game.store.toggle_collection(id)
	var value:Dictionary=game.store.collection();value.title="Treasures After Dark";value.featured="birth_of_venus";value.art_ids.erase("birth_of_venus");value.art_ids.push_front("birth_of_venus");game.store.save_collection(value)
	game._show_lobby();await shot("home")
	game._show_gallery("paintings");game.screen_view.floor_number=1;game.screen_view.refresh();await shot("originals")
	game.screen_view._open_floor_menu();await shot("floor-list");game.screen_view._close_floor_menu()
	game.screen_view._toggle_pixels();await shot("pixels")
	game.open_painting("birth_of_venus");await shot("detail")
	game.overlay.get_node("Card/ViewMode").pressed.emit();await shot("detail-pixels");game._close_modal()
	game.screen_view.floor_number=3;game.screen_view.pixels=false;game.screen_view.refresh();await shot("floor-3-originals")
	game.screen_view.floor_number=10;game.screen_view.refresh();await shot("floor-10-originals")
	game.open_painting(game.campaign.stage_slots(10)[0].art_id);await shot("future-original-detail");game._close_modal()
	game.screen_view._switch("crew");await shot("crew")
	game.screen_view._switch("collection");game.screen_view.pixels=false;game.screen_view.refresh();await shot("collection")
	game.screen_view.editing=true;game.screen_view.refresh();await shot("edit")
	game.screen_view._place_art("birth_of_venus");await shot("edit-selected")
	game.screen_view._choose_layout("pairs");await shot("edit-pairs")
	game.screen_view._choose_layout("salon");await shot("edit-salon")
	game.screen_view._choose_layout("spotlight")
	await process_frame
	game.screen_view.content.get_node("CollectionScroll").scroll_vertical=10000;await shot("edit-library")
	root.size=Vector2i(390,844);game.screen_view.collection_scroll_offset=0;game.screen_view.refresh();await shot("tall-edit")
	game.screen_view.editing=false;game.screen_view.refresh();await shot("tall-collection-full")
	root.size=Vector2i(720,1280)
	game.screen_view.photo_mode=true;game.screen_view.refresh();await shot("photo")
	var error:int=await game.screen_view.export_photo("res://artifacts/museum-export-4x5.png")
	if error!=OK:printerr("FAIL: 4x5 PNG export");quit(1);return
	game.screen_view.portrait_photo=true;game.screen_view.pixels=true
	error=await game.screen_view.export_photo("res://artifacts/museum-export-9x16.png")
	if error!=OK:printerr("FAIL: 9x16 PNG export");quit(1);return
	game.store.toggle_collection("sun_seal")
	value=game.store.collection();value.art_ids=["birth_of_venus"];value.featured="birth_of_venus";value.art_ids.erase("birth_of_venus");value.art_ids.push_front("birth_of_venus");game.store.save_collection(value)
	game.screen_view.portrait_photo=false;game.screen_view.pixels=false
	error=await game.screen_view.export_photo("res://artifacts/museum-export-single.png")
	if error!=OK:printerr("FAIL: one-work PNG export");quit(1);return
	root.size=Vector2i(390,844);game.screen_view.photo_mode=false;game.screen_view.editing=false;game.screen_view.refresh();await shot("tall")
	game.screen_view._switch("paintings");game.screen_view._select_floor(10);await shot("tall-floors");game.screen_view._open_floor_menu();await shot("tall-floor-list");game.screen_view._close_floor_menu()
	game.open_painting("sun_seal");await shot("tall-detail");game._close_modal()
	Fixture.cleanup(game);game.queue_free();await process_frame
	print("MUSEUM CAPTURES: 28 | FAILURES: 0")
	quit()
