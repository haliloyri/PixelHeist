extends RefCounted
## Deterministic scenes with a save path assigned BEFORE _ready can run.
const MainScene = preload("res://scenes/main.tscn")

static func create_game() -> Control:
	seed(412)
	var temp_root := OS.get_environment("PIXEL_HEIST_TEST_DIR")
	if temp_root.is_empty():
		temp_root = OS.get_environment("TEMP") if OS.has_feature("windows") else OS.get_environment("TMPDIR")
	if temp_root.is_empty():
		temp_root = "/tmp"
	var directory := temp_root.path_join("pixel-heist-%d-%d" % [OS.get_process_id(), Time.get_ticks_usec()])
	var error := DirAccess.make_dir_recursive_absolute(directory)
	assert(error == OK, "Cannot create isolated test save directory")
	var game := MainScene.instantiate()
	game.test_mode = true
	game.skip_heist_intro = true
	game.save_path = directory.path_join("progress.cfg")
	game.set_meta("test_save_directory", directory)
	return game

static func cleanup(game: Control) -> void:
	game.test_mode = true
	var directory: String = game.get_meta("test_save_directory")
	assert(game.save_path == directory.path_join("progress.cfg"), "Fixture save path was unexpectedly replaced")
	clear_save_files(game)
	var error := DirAccess.remove_absolute(directory)
	assert(error == OK, "Cannot remove fixture directory")

static func clear_save_files(game: Control) -> void:
	var directory: String = game.get_meta("test_save_directory")
	assert(game.save_path == directory.path_join("progress.cfg"), "Fixture path changed")
	for suffix in ["", ".v1", ".v1.bak", ".v2", ".v2.bak", ".v2.tmp", ".v2.bak.tmp", ".v1.tmp", ".v1.bak.tmp", ".budget", ".budget.bak", ".budget.tmp", ".budget.bak.tmp", ".worker.log"]:
		var path: String = game.save_path + suffix
		if FileAccess.file_exists(path):
			var error := DirAccess.remove_absolute(path)
			assert(error == OK, "Cannot remove fixture file")
