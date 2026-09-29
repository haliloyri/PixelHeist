extends SceneTree
const Fixture = preload("res://tests/fixture.gd")
const Pixels = preload("res://scripts/ui/artwork_pixels.gd")
const Packets = preload("res://scripts/core/packet_queues.gd")
var checks := 0
var failures := 0
func check(ok: bool, message: String) -> void:
	checks+=1
	if not ok: failures+=1;printerr("FAIL: ",message)
func _initialize() -> void: call_deferred("run")
func run() -> void:
	var game = Fixture.create_game();root.add_child(game);await process_frame
	game.set_process(false);game.app_suspended=false
	game.store.apply(func(s):s.story.opening=true;return true)
	var current: Dictionary = game.levels[0].duplicate(true)
	var gleaners: Dictionary = game.levels[10]
	var reference_pitch: float = minf(436.0/float(gleaners.width),290.0/float(gleaners.height))
	check(gleaners.art_id=="the_gleaners" and gleaners.width==28 and gleaners.height==22,"Reference painting retains its 28x22 grid")
	check(current.art_id=="sun_seal" and current.width==22 and current.height==22,"Square Sun Seal matches the reference pixel size at its own aspect ratio")
	check(current.cells.size()==484 and not current.has("cell_colors"),"Transitions use matching palette colors, not independent tones")
	check(current.palette.size()==5,"Five readable colors drive both cubes and carriers")
	check(game.level_for("sun_seal").cells==current.cells,"Museum uses the new sampled artwork")
	for i in range(1,game.levels.size()):check(not game.levels[i].has("cell_colors"),"Other artwork is unchanged")
	game._start_level(0)
	check(game.puzzle.total==484 and game.puzzle.dock_count()==5,"New game uses 484 cells and five shared docks")
	check(not current.palette.has(current.board_backing),"Cool backing is absent from the playable palette")
	check(is_equal_approx(game.depth_view.tile_size,reference_pitch*.01),"Sun Seal uses The Gleaners' exact on-screen pixel pitch")
	check(is_equal_approx(game.board_art.art_rect().size.x,290.0) and is_equal_approx(game.board_art.art_rect().size.y,290.0) and game.frame_rect().position.y>120,"Square artwork fills the reference height below the HUD")
	var count_label: Label = game.screen_view.get_node("ProgressLabel")
	check(count_label.position.y + count_label.size.y < game.frame_rect().position.y,"Progress and frame stay separate")
	check(game.screen_view.get_node("ArtifactTitle").position.y<game.board_art.position.y,"Artwork name sits on the upper frame")
	var mystery := 0
	var visible := 0
	for lane in current.lanes:
		for packet in lane:
			if packet.get("mystery",false): mystery+=1
			else: visible+=1
	check(mystery>0 and visible>mystery,"Most waiting cubes show their real colors")
	check(game.depth_view.raised,"Gameplay uses raised block geometry")
	for cell in [0,21,60,180,320,483]:
		check(Pixels.color_at(current,cell)==Color(current.palette[int(current.cells[cell])]),"Visible pixel is exactly its carrier color")
	var job: Dictionary = game.heist_checkpoint.capture(game)
	check(game.heist_checkpoint.validate(job,game.levels).is_empty(),"New artwork checkpoint is valid")
	game._resume_heist(job)
	check(game.puzzle.snapshot()==job.puzzle,"New artwork resumes exactly")
	# Real preserved old boards, with both small and large historical queues.
	for version in [0,1,2,3,4,5,6]:
		var old: Dictionary = current.previous_versions[0].duplicate(true)
		if version==1: old=game.all_levels[0].duplicate(true)
		if version>=2: old=current.previous_versions[version-1].duplicate(true)
		game.levels[0]=old;game._start_level(0)
		game._deploy(0)
		for tick in 30: game._process(.05)
		job=game.heist_checkpoint.capture(game)
		game.levels[0]=current
		check(game.heist_checkpoint.validate(job,game.levels).is_empty(),"Old in-flight board stays valid after the new artwork ships")
		check(not Packets.migrate(game.puzzle,current),"No queue migration across different boards")
		var balance: Dictionary = game.store.state.duplicate(true)
		game._resume_heist(job)
		check(game.current_level().cells==old.cells and game.puzzle.board==job.puzzle.board,"Old board and picked pixels survive resume")
		check(game.flights.size()==job.motion.flights.size(),"Old ant flights survive resume")
		check(game.store.state==balance,"Resume does not change wallet or progress")
		check(game.heist_checkpoint.validate(game.heist_checkpoint.capture(game),game.levels).is_empty(),"Resumed old artwork can be saved again")
	game._start_level(0)
	check(game.current_level().cells==current.cells,"Next fresh attempt uses the new painting")
	var bad: Dictionary = game.heist_checkpoint.capture(game)
	bad.content_hash=""
	check(not game.heist_checkpoint.validate(bad,game.levels).is_empty(),"Unknown/empty board hash is rejected")
	var sim_time := 0.0
	for value in current.solution:
		var guard := 0
		while game.busy and guard<10000 and game.screen=="play":
			game._process(.1);guard+=1;sim_time+=.1
		if guard>=10000:check(false,"A carrier route must settle");break
		check(game.puzzle.can_deploy(int(value)),"Authored packet can enter a shared dock")
		game._deploy(int(value))
		check(game.heist_checkpoint.validate(game.heist_checkpoint.capture(game),game.levels).is_empty(),"Live route preserves pixel budget")
	var guard := 0
	while game.screen=="play" and guard<20000:
		game._process(.1);guard+=1;sim_time+=.1
	check(game.screen=="complete" and game.puzzle.remaining==0,"Full Sun Seal flight simulation wins without boosters")
	check(game.store.state.completed.has("sun_seal") and game.store.state.session.is_empty(),"Win keeps the existing artwork identity and clears the session")
	print("SUN SEAL SIMULATED SECONDS: ",sim_time)
	Fixture.cleanup(game);game.queue_free();await process_frame
	print("SOURCE PIXELS CHECKS: %d | FAILURES: %d"%[checks,failures])
	quit(1 if failures else 0)
