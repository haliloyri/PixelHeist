extends SceneTree
## Interactive Level 1 pilot with a fresh, isolated save. Never opens player progress.
const Fixture=preload("res://tests/fixture.gd")
var game
func _initialize()->void:call_deferred("run")
func run()->void:
	var museum_replay:bool=OS.get_cmdline_user_args().has("--museum-replay")
	root.title="Pixel Heist — Museum Replay Playtest" if museum_replay else "Pixel Heist — Sun Seal Playtest"
	game=Fixture.create_game()
	game.skip_heist_intro=false
	root.add_child(game);await process_frame
	game.store.apply(func(s):s.story.opening=true;s.gold=1000;return true)
	if museum_replay:
		game.store.record_win("sun_seal","",3)
		game._show_gallery("paintings")
		game.open_painting("sun_seal")
	else:
		game._start_level(0)
	print("SUN SEAL PLAYTEST: isolated save at ",game.save_path)
