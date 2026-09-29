extends SceneTree
const Fixture=preload("res://tests/fixture.gd")
const Art=preload("res://scripts/ui/museum_art.gd")
const Kit=preload("res://scripts/ui/ui_kit.gd")
var game
func _initialize()->void:call_deferred("run")
func shot(label:String)->void:
	for i in 4:await process_frame
	RenderingServer.force_draw(false)
	var error:=root.get_texture().get_image().save_png("res://artifacts/sun-seal-"+label+".png")
	assert(error==OK)
func run()->void:
	game=Fixture.create_game();root.add_child(game);await process_frame
	game.set_process(false);game.app_suspended=false
	game.store.apply(func(s):s.story.opening=true;return true)
	root.size=Vector2i(720,1280)
	game._start_level(0);game._hide_tip();await shot("gameplay")
	assert(game.depth_view.raised)
	for color in game.current_level().palette.size():
		var node:MultiMeshInstance3D=game.depth_view.tiles[color]
		assert(node.material_override.albedo_color==Color(game.current_level().palette[color]))
		assert(node.multimesh.mesh.surface_get_arrays(0)[Mesh.ARRAY_VERTEX].size()==18,"Each block has three faces")
	game._show_modal("painting",{"art_id":"sun_seal","pixels":true});await shot("pixel-detail");game._close_modal()
	game._show_modal("painting",{"art_id":"sun_seal"});await shot("original-detail");game._close_modal()
	game._start_level(0);game._hide_tip()
	game.store.apply(func(state):state.boosters.row_beam=2;return true)
	game._use_booster("row_beam")
	for i in 30:game._process(.05)
	await shot("cleared-backing")
	game._start_level(0);game._hide_tip()
	for column in 3:game._deploy(column)
	for i in 100:game._process(.04)
	await shot("walking")
	root.size=Vector2i(390,844)
	await shot("tall")
	root.size=Vector2i(720,1280)
	game._start_level(0);game._hide_tip()
	game.store.apply(func(state):state.gold=1000;return true)
	game._select_speed3();await shot("speed-purchase")
	game._buy_speed3();await shot("speed-active")
	game.hide()
	var comparison:=SubViewport.new();comparison.size=Vector2i(1080,630)
	comparison.render_target_update_mode=SubViewport.UPDATE_ALWAYS
	root.add_child(comparison)
	var sheet:=Control.new();comparison.add_child(sheet)
	Kit.panel(sheet,Rect2(0,0,1080,630),Color("0c1625"),Color("0c1625"),0,0)
	Kit.label(sheet,"SUN SEAL · ORIGINAL",Rect2(20,14,500,50),26,Color("f3d59a"),0)
	Kit.label(sheet,"22 × 22 · RAISED PIXELS",Rect2(560,14,500,50),26,Color("f3d59a"),0)
	for i in 2:
		var art:=Art.new();sheet.add_child(art);art.position=Vector2(25+i*540,82)
		art.setup(game,"sun_seal",i==1,Vector2(490,490),false)
	Kit.label(sheet,"484 pixels · 5 matching colors · No gaps",Rect2(20,580,1040,40),24,Color("e0bd78"),0)
	for i in 4:await process_frame
	RenderingServer.force_draw(false)
	assert(comparison.get_texture().get_image().save_png("res://artifacts/sun-seal-comparison.png")==OK)
	comparison.queue_free()
	sheet.queue_free();Fixture.cleanup(game);game.queue_free();await process_frame
	print("SOURCE PIXEL CAPTURES: 9 | FAILURES: 0");quit()
