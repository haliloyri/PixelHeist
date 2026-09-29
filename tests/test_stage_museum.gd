extends SceneTree
const Fixture=preload("res://tests/fixture.gd")
const Store=preload("res://scripts/services/progress_store.gd")
const Atomic=preload("res://scripts/services/atomic_store.gd")
const Originals=preload("res://scripts/ui/heist_intro.gd")
var checks:=0
var failures:=0
func check(ok:bool,label:String)->void:
	checks+=1
	if not ok:failures+=1;printerr("FAIL: ",label)
func _initialize()->void:call_deferred("run")
func run()->void:
	var game=Fixture.create_game();root.add_child(game)
	await process_frame
	game.set_process(false)
	check(game.campaign.stages.size()==10,"Ten named stages")
	var slots:Array=[]
	var stage_ids:Dictionary={}
	for n in range(1,11):
		var stage:Dictionary=game.campaign.stage_by_number(n)
		check(not stage_ids.has(stage.id) and not stage.title.is_empty(),"Stable unique stage ID and name")
		stage_ids[stage.id]=true
		var floor_slots:Array=game.campaign.stage_slots(n)
		check(floor_slots.size()==10,"Ten exhibition slots per floor")
		for slot in floor_slots:slots.append(slot.level)
	var ordered:bool=slots.size()==100
	if ordered:
		for i in 100:
			if int(slots[i])!=i+1:ordered=false;break
	check(ordered,"Every level 1..100 has one floor slot")
	check(game.campaign.stage_for_level(10).number==1 and game.campaign.stage_for_level(11).number==2 and game.campaign.stage_for_level(100).number==10,"Stage boundaries")
	check(not game.campaign.stage_slots(2)[5].art_id.is_empty() and game.campaign.order().size()==15,"Original assignments do not invent playable content")
	var legacy:Dictionary=game.store.state.duplicate(true)
	legacy.erase("collection")
	check(game.store.validate(legacy)=="","Existing v2 saves remain valid")
	check(game.store.commit(legacy)==OK,"Can persist an old v2 payload")
	var old_gold:int=game.store.state.gold
	var reloaded:=Store.new();reloaded.open(game.save_path)
	check(reloaded.collection().art_ids.is_empty() and int(reloaded.state.gold)==old_gold,"Loading old saves adds empty room without grants")
	game.store=reloaded
	for id in game.campaign.order():game.store.record_win(id,"",3)
	check(game.campaign.stage_progress(1,game.store.state.completed)==10 and game.campaign.stage_progress(2,game.store.state.completed)==5,"Floors use owned work counts")
	var wallet:int=game.store.state.gold
	var owned:Array=game.store.state.completed.duplicate()
	for id in game.campaign.order().slice(0,10):check(game.store.toggle_collection(id),"Owned work can be selected")
	var saved:Dictionary=game.store.state.duplicate(true)
	check(not game.store.toggle_collection(game.campaign.order()[10]) and game.store.state==saved,"Eleventh work rejected atomically")
	var value:Dictionary=game.store.collection()
	value.art_ids[1]=value.art_ids[0]
	check(not game.store.save_collection(value),"Duplicate artwork rejected")
	value=game.store.collection();value.art_ids[0]="unknown_work"
	check(not game.store.save_collection(value),"Unowned/unknown artwork rejected")
	value=game.store.collection();value.featured="unknown_work"
	check(not game.store.save_collection(value),"Featured work must be selected")
	value=game.store.collection();value.theme="invalid"
	check(not game.store.save_collection(value),"Unknown theme rejected")
	value=game.store.collection();value.title="Bad\nTitle"
	check(not game.store.save_collection(value),"Control characters rejected")
	value=game.store.collection();value.title="My Night Museum";value.theme="emerald";value.featured=value.art_ids[3]
	check(game.store.save_collection(value),"Title, theme and feature saved")
	var featured:String=value.featured
	check(game.store.move_collection(featured,-1) and game.store.collection().art_ids[2]==featured,"Order moves and persists")
	check(game.store.toggle_collection(featured) and game.store.collection().featured=="","Removing featured work clears its feature")
	check(game.store.state.completed==owned and int(game.store.state.gold)==wallet,"Editing does not remove ownership or charge gold")
	var committed:Dictionary=game.store.collection()
	game.store.read_only=true
	check(not game.store.toggle_collection(game.campaign.order()[10]) and game.store.collection()==committed,"Failed save keeps committed selection")
	game.store.read_only=false
	var reopened:=Store.new();reopened.open(game.save_path)
	check(reopened.collection()==committed,"Room survives reload")
	game.store=reopened
	# Milestone claim identities survive the stage regrouping.
	var first:Dictionary=game.campaign.chapter_by_number(1)
	game.store.claim_chapter_chest(first)
	wallet=game.store.state.gold
	check(game.store.claim_chapter_chest(first).is_empty() and game.store.state.gold==wallet,"No duplicate stage-migration reward")
	game._show_lobby()
	check(game.screen_view.progress_dots.size()==10 and game.screen_view.progress_value.text=="5 / 10","Home shows Stage 2 partial progress after fifteen wins")
	game._show_gallery("paintings")
	var museum=game.screen_view
	check(museum.floor_number==2 and not museum.pixels,"Museum opens current floor with originals")
	for name in ["Tab_paintings","Tab_collection","Tab_crew","ViewMode","FloorPicker"]:
		var button:Button=museum.content.get_node(name)
		check(button.text.is_empty() and not button.tooltip_text.is_empty() and button.has_node("Icon"),"Museum navigation uses a labelled icon: "+name)
	check(not museum.content.has_node("MuseumNav") and not museum.content.has_node("Shop") and not museum.content.has_node("Home"),"Museum omits the bottom navigation")
	var back:Button=museum.content.get_node("MuseumBack")
	check(back.tooltip_text=="Back to Safehouse" and back.size==Vector2(76,64),"Upper-left back has a labelled touch target")
	check(not back.get_rect().intersects(museum.content.get_node("MuseumTitle").get_rect()),"Back and centered Museum title do not overlap")
	check(is_equal_approx(museum.content.get_node("FloorCorridor").get_rect().end.y,museum.size.y-12),"Exhibition reclaims the footer area")
	check(not museum.content.has_node("PrevFloor") and not museum.content.has_node("NextFloor"),"One right-side floor picker replaces previous/next controls")
	var before_browse:Dictionary=game.store.state.duplicate(true)
	museum.content.get_node("FloorPicker").pressed.emit()
	await process_frame
	var rows:VBoxContainer=museum.content.get_node("FloorMenu/Directory/FloorList/Rows")
	check(rows.get_child_count()==10,"Custom floor list contains all ten named stages")
	check(rows.get_node("Floor2").has_focus(),"Current floor receives keyboard focus")
	museum.content.get_node("FloorMenu/Dismiss").pressed.emit()
	check(not museum.content.has_node("FloorMenu") and museum.floor_number==2,"Outside click closes list without changing floor")
	museum._open_floor_menu()
	var escape:=InputEventAction.new();escape.action="ui_cancel";escape.pressed=true
	museum._input(escape)
	check(not museum.content.has_node("FloorMenu") and museum.content.get_node("FloorPicker").has_focus(),"Escape closes list and restores picker focus")
	museum._open_floor_menu()
	museum.content.get_node("FloorMenu/Directory/FloorList/Rows/Floor10").pressed.emit()
	check(museum.floor_number==10 and museum.floor_scroll_offset==0 and not museum.content.has_node("FloorMenu"),"List selection opens chosen floor at top and closes list")
	check(game.store.state==before_browse,"Browsing future floors changes no ownership, save or wallet")
	museum._select_floor(2)
	var floor_scroll:ScrollContainer=museum.content.get_node("FloorCorridor")
	check(floor_scroll.vertical_scroll_mode==ScrollContainer.SCROLL_MODE_AUTO and floor_scroll.horizontal_scroll_mode==ScrollContainer.SCROLL_MODE_DISABLED,"Floor uses vertical scrolling")
	var floor_grid:Control=floor_scroll.get_node("FloorGrid")
	check(floor_grid.get_child_count()==10,"All ten floor slots are present in level order")
	museum._floor(99)
	check(museum.floor_number==10,"Floor switch clamps at ten")
	museum._floor(-99)
	check(museum.floor_number==1,"Floor switch clamps at one")
	museum._toggle_pixels()
	check(museum.pixels,"Pixel mode is a presentation switch")
	check(museum.content.get_node("ViewMode/Icon").get("kind")=="original","Pixel mode offers a framed-original icon for return")
	var locked_id:String=game.campaign.order()[4]
	game.store.state.completed.erase(locked_id)
	museum.floor_number=1;museum.pixels=false;museum.refresh()
	var locked_frame:Control=museum.content.get_node("FloorCorridor/FloorGrid/Frame4")
	var owned_frame:Control=museum.content.get_node("FloorCorridor/FloorGrid/Frame0")
	check(locked_frame.get_node_or_null("Open")!=null and locked_frame.get_child_count()>2,"Authored locked art stays visible and tappable")
	check(str(locked_frame.get_node("Open").text).is_empty(),"Artwork itself is the detail target, without View text")
	var lock_badges:=locked_frame.find_children("*","Panel",false,false)
	check(lock_badges.size()==1 and owned_frame.find_children("*","Panel",false,false).is_empty(),"Only locked artwork receives a status badge")
	for index in [2,3]:
		var id:String=game.campaign.order()[index]
		var tile:Control=museum.content.get_node("FloorCorridor/FloorGrid/Frame%d"%index)
		var art:Control=tile.get_child(0)
		var source_ratio:float=Originals.artwork_texture(id).get_size().aspect()
		var fitted:Rect2=art.get("picture_rect")
		var fitted_ratio:float=fitted.size.aspect()
		check(absf(source_ratio-fitted_ratio)<.001,"Portrait and landscape frames retain original aspect ratio")
	game.open_painting(locked_id)
	check(game.modal_kind=="painting" and game.overlay.find_child("Collection",true,false)==null,"Locked art opens detail without collection action")
	check(game.overlay.find_child("Replay",true,false)==null,"Locked artwork cannot be replayed")
	check(game.overlay.find_child("ViewMode",true,false).text.is_empty() and game.overlay.find_child("Close",true,false).text.is_empty(),"Artwork detail actions use icons")
	game._close_modal()
	game.store.state.completed.append(locked_id)
	museum._switch("collection")
	check(museum.content.has_node("CollectionScroll/CollectionBody/CollectionRoom"),"Private room is part of Museum")
	for name in ["EditCollection","PhotoMode","ViewMode"]:
		var button:Button=museum.content.get_node(name)
		check(button.text.is_empty() and button.has_node("Icon"),"Collection action uses an icon: "+name)
	museum.editing=true;museum.refresh()
	check(museum.content.get_node("RoomTheme").text.is_empty() and museum.content.get_node("RoomTheme").has_node("Icon"),"Room theme picker is an icon with a visible value label")
	# Saved layouts, visible ordering and atomic tap-to-swap use actual artwork IDs.
	var before_edit:Dictionary=game.store.state.duplicate(true)
	var room_script=preload("res://scripts/ui/collection_room.gd")
	for layout in room_script.LAYOUTS:
		museum.content.get_node("Layout_"+layout).pressed.emit()
		check(game.store.collection().layout==layout,"Layout button persists "+layout)
		var layout_reload:=Store.new();layout_reload.open(game.save_path)
		check(layout_reload.collection().layout==layout,"Layout survives reload "+layout)
		for count in range(1,11):
			for extent in [Vector2(640,room_script.live_height(count,layout,640)),Vector2(1080,1350),Vector2(1080,1920)]:
				var rects:Array=room_script.arrangement(count,layout,extent)
				var valid:=rects.size()==count
				for i in rects.size():
					valid=valid and Rect2(Vector2.ZERO,extent).encloses(rects[i]) and rects[i].size.y>80
					for j in range(i+1,rects.size()):valid=valid and not rects[i].intersects(rects[j])
				check(valid,"Distinct artwork bounds for %s / %d / %s"%[layout,count,extent])
	museum._choose_layout("spotlight")
	var first_id:String=game.store.collection().art_ids[0]
	var last_id:String=game.store.collection().art_ids.back()
	var room:Control=museum.content.get_node("CollectionScroll/CollectionBody/CollectionRoom")
	room.get_node("Place_"+first_id).pressed.emit()
	check(museum.selected_art==first_id,"Room tap selects artwork")
	museum.content.get_node("CollectionScroll/CollectionBody/CollectionRoom/Place_"+last_id).pressed.emit()
	check(game.store.collection().art_ids[0]==last_id and game.store.collection().art_ids.back()==first_id,"Second room tap swaps actual positions")
	museum._place_art(first_id)
	museum.content.get_node("MoveFirst").pressed.emit()
	check(game.store.collection().art_ids[0]==first_id,"First-position action changes the hero")
	museum.content.get_node("MoveLater").pressed.emit()
	check(game.store.collection().art_ids[1]==first_id,"Arrow moves the visible hero into the next row")
	museum.content.get_node("MoveEarlier").pressed.emit()
	check(game.store.collection().art_ids[0]==first_id,"Arrow restores first position")
	museum.content.get_node("RemoveSelected").pressed.emit()
	check(not game.store.collection().art_ids.has(first_id) and game.store.state.completed.has(first_id),"Remove frees a place but preserves permanent ownership")
	museum.content.find_child("Select_"+first_id,true,false).pressed.emit()
	check(game.store.collection().art_ids.back()==first_id,"Owned-art library adds work to the last position")
	museum._place_art(first_id)
	museum._rename("A Room of Treasures")
	check(game.store.collection().title=="A Room of Treasures" and museum.content.get_node("CollectionScroll/CollectionBody/CollectionRoom/CollectionTitle").text=="A Room of Treasures","Room title updates in place after save")
	var edit_committed:Dictionary=game.store.collection()
	game.store.read_only=true
	museum._rename("Cannot Save This")
	check(museum.content.get_node("CollectionName").text==edit_committed.title,"Failed rename restores the committed input")
	museum._choose_layout("pairs")
	museum._place_art(last_id)
	check(game.store.collection()==edit_committed,"Failed layout and swap writes preserve committed room")
	game.store.read_only=false
	var invalid_layout:Dictionary=edit_committed.duplicate(true);invalid_layout.layout="unknown"
	check(not game.store.save_collection(invalid_layout),"Unknown layout rejected atomically")
	var old_room:Dictionary=edit_committed.duplicate(true);old_room.erase("layout");old_room.featured=last_id
	check(game.store.save_collection(old_room),"Pre-layout room remains loadable")
	var legacy_reload:=Store.new();legacy_reload.open(game.save_path)
	check(legacy_reload.collection().layout=="spotlight" and legacy_reload.collection().art_ids[0]==last_id,"Legacy featured work keeps its visible first position")
	game.store.save_collection(edit_committed)
	check(game.store.state.completed==before_edit.completed and game.store.state.gold==before_edit.gold and game.store.state.energy==before_edit.energy,"Layout edits preserve ownership, wallet and energy")
	museum.selected_art="";museum.editing=false;museum.refresh()
	for action in ["EditCollection","PhotoMode","ViewMode"]:
		var control:Control=museum.content.get_node(action)
		check(control.position.y>museum.content.get_node("CollectionScroll").get_rect().end.y and control.get_rect().end.y<=museum.size.y-28,"Collection action shelf has clearance: "+action)
	var tab_label:Label=museum.content.get_node("Tab_collection/Caption")
	check(tab_label.get_global_rect().end.y+6<museum.content.get_node("MuseumTabs").global_position.y+103,"Selected underline clears the tab caption")
	museum.photo_mode=true;museum.refresh()
	check(museum.content.has_node("PhotoPreview") and not museum.content.has_node("Home"),"Photo preview omits museum navigation")
	check(museum.photo_size()==Vector2(1080,1350),"4:5 export size")
	museum.portrait_photo=true
	check(museum.photo_size()==Vector2(1080,1920),"9:16 export size")
	var before_back:Dictionary=game.store.state.duplicate(true)
	museum.content.get_node("PhotoBack").pressed.emit()
	check(game.screen=="gallery" and not museum.photo_mode and museum.tab=="collection","Photo back returns to Collection")
	museum.content.get_node("EditCollection").pressed.emit()
	museum.content.get_node("CollectionName").text="Back Button Collection"
	museum.content.get_node("MuseumBack").pressed.emit()
	check(game.screen=="gallery" and not museum.editing and museum.tab=="collection","First back exits Edit without leaving Collection")
	check(game.store.collection().title=="Back Button Collection","Back commits the focused room title")
	var back_key:=InputEventKey.new();back_key.keycode=KEY_ESCAPE;back_key.pressed=true
	museum.content.get_node("EditCollection").pressed.emit()
	game._unhandled_key_input(back_key)
	check(game.screen=="gallery" and not museum.editing,"Escape also exits Edit first")
	game.open_painting(game.campaign.order()[0])
	game._unhandled_key_input(back_key)
	check(game.screen=="gallery" and game.modal_kind.is_empty(),"Escape closes Artwork Detail before navigating")
	for tab_id in ["collection","paintings","crew"]:
		museum._switch(tab_id)
		check(not museum.content.has_node("MuseumNav") and museum.content.has_node("MuseumBack"),"All Museum tabs use back navigation: "+tab_id)
		museum.content.get_node("MuseumBack").pressed.emit()
		check(game.screen=="lobby","Back returns to Safehouse from "+tab_id)
		game._show_gallery(tab_id);museum=game.screen_view
	game._unhandled_key_input(back_key)
	check(game.screen=="lobby","Escape leaves normal Museum view for Safehouse")
	check(game.store.state.completed==before_back.completed and game.store.state.gold==before_back.gold and game.store.state.energy==before_back.energy and game.store.collection().art_ids==before_back.collection.art_ids,"Back navigation preserves progression, economy and collection order")
	game._show_gallery("collection");museum=game.screen_view
	game.open_painting(game.campaign.order()[0])
	check(game.modal_kind=="painting","Owned painting opens detail")
	check(game.overlay.find_child("Collection",true,false).text.is_empty(),"Owned collection action is icon-only")
	check(game.overlay.get_node("Card/Replay").text=="Play again","Owned playable painting offers a clear replay button")
	var detail_card:Panel=game.overlay.get_node("Card")
	var detail_art:Control=detail_card.get_node("Artwork")
	var detail_button:Button=detail_card.get_node("ViewMode")
	var detail_children:int=game.overlay.get_child_count()
	check(not bool(detail_art.get("pixels_mode")) and detail_art.get_child(0) is TextureRect,"Detail starts with its original image")
	detail_button.pressed.emit()
	check(game.modal_kind=="painting" and game.overlay.get_child_count()==detail_children and game.overlay.get_node("Card")==detail_card,"Pixel switch keeps the same detail modal")
	check(detail_card.get_node("Artwork")==detail_art and detail_card.get_node("ViewMode")==detail_button,"Pixel switch retains the artwork area and its control")
	check(bool(detail_art.get("pixels_mode")) and detail_art.get_child_count()==1 and not (detail_art.get_child(0) is TextureRect),"Only the artwork changes to pixels")
	check(detail_button.get_node("Icon").get("kind")=="original" and detail_button.tooltip_text=="Show Originals","Pixel detail offers the original-image action")
	detail_button.pressed.emit()
	check(game.overlay.get_node("Card")==detail_card and not bool(detail_art.get("pixels_mode")) and detail_art.get_child_count()==1 and detail_art.get_child(0) is TextureRect,"Second tap restores the original in the same modal")
	check(detail_button.get_node("Icon").get("kind")=="pixels" and detail_button.tooltip_text=="Show Pixels","Original detail offers the pixel action again")
	detail_button.pressed.emit()
	detail_card.get_node("Collection").pressed.emit()
	check(game.modal_kind=="painting" and bool(game.overlay.get_node("Card/Artwork").get("pixels_mode")),"Collection edit preserves the current pixel view")
	check(game.overlay.get_node("Card/Replay").text=="Play again","Replay remains available after a collection edit")
	game._close_modal();game.open_painting("unowned")
	check(game.modal_kind=="","Unknown artwork detail is blocked")
	var future_id:String=game.campaign.stage_slots(10)[0].art_id
	game.open_painting(future_id)
	check(game.modal_kind=="painting" and game.art_title(future_id)!=future_id and game.overlay.find_child("Collection",true,false)==null,"Future locked original has a named preview without collection action")
	check(game.overlay.find_child("ViewMode",true,false)==null,"Future original does not promise an unauthored pixel board")
	check(game.overlay.find_child("Replay",true,false)==null,"Future original cannot start an unauthored heist")
	game._close_modal()
	game.open_painting("birth_of_venus")
	game.store.apply(func(s):s.energy=0;s.energy_at=int(Time.get_unix_time_from_system());return true)
	var pending:Dictionary=game.store.state.session.duplicate(true)
	game.overlay.get_node("Card/Replay").pressed.emit()
	check(game.screen=="gallery" and game.modal_kind=="out_of_energy" and game.store.state.session==pending,"Replay with no energy opens the existing energy popup without starting a heist")
	game._close_modal()
	game.store.apply(func(s):s.energy=10;return true)
	game.open_painting("birth_of_venus")
	game.overlay.get_node("Card/Replay").pressed.emit()
	check(game.screen=="play" and game.current_level().art_id=="birth_of_venus" and game.puzzle.remaining==game.puzzle.total,"Replay starts a fresh heist for the selected painting")
	check(game.store.state.session.get("art_id")=="birth_of_venus" and int(game.store.state.energy)==10 and game.store.state.completed.has("birth_of_venus"),"Replay saves the selected art without charging energy or losing ownership")
	Fixture.cleanup(game);game.queue_free();await process_frame
	print("STAGE MUSEUM CHECKS: %d | FAILURES: %d"%[checks,failures])
	quit(1 if failures else 0)
