extends SceneTree
const Fixture = preload("res://tests/fixture.gd")
const Catalog = preload("res://scripts/services/campaign_catalog.gd")
const Puzzle = preload("res://scripts/core/puzzle_state.gd")
const Packets = preload("res://scripts/core/packet_queues.gd")
const Checkpoint = preload("res://scripts/services/heist_checkpoint.gd")
const HeistStyle = preload("res://scripts/ui/heist_skin.gd")
const AntSkin = preload("res://scripts/ui/ant_skin.gd")
var checks := 0
var failures := 0
func check(ok: bool,label: String) -> void:
	checks += 1
	if not ok: failures += 1; printerr("FAIL: ",label)
func _initialize() -> void: call_deferred("run")
func budget(puzzle) -> Dictionary:
	var counts := {}
	for lane in puzzle.lanes:
		for packet in lane:
			if not packet.get("decoy",false): counts[int(packet.color)] = int(counts.get(int(packet.color),0))+int(packet.amount)
	return counts
func run() -> void:
	var source: Array = JSON.parse_string(FileAccess.get_file_as_string("res://data/levels.json"))
	var levels: Array = Catalog.new().levels(source)
	for level in levels:
		var puzzle = Puzzle.new()
		puzzle.setup(level)
		puzzle.establish_docks(5)
		var totals := {}
		for cell in level.cells:
			if int(cell) >= 0: totals[int(cell)] = int(totals.get(int(cell),0))+1
		check(budget(puzzle)==totals,"New queues exactly conserve every artwork color: "+level.art_id)
		for lane in puzzle.lanes:
			for packet in lane:
				if not packet.get("decoy",false): check(int(packet.amount)>=20 or int(totals[int(packet.color)])<20,"Sub-20 packets exist only when the artwork has fewer than 20 of that color")
		for value in level.solution:
			puzzle.settle()
			var col := int(value)
			if col < 0: puzzle.expire_front(-col-1)
			else: check(puzzle.deploy(col),"Authored large-packet solution has a free dock")
		puzzle.settle()
		check(puzzle.remaining==0,"Large-packet solution wins: "+level.art_id)
		# Convert a genuine old queue in place after some work, without moving board/active state.
		var old = Puzzle.new()
		old.setup(source[levels.find(level)])
		old.establish_docks(5)
		for col in old.slot_count:
			if old.can_deploy(col): old.deploy(col); break
		var event: Dictionary = old.reserve()
		if not event.is_empty(): old.pickup(int(event.id))
		var before: Dictionary = old.snapshot()
		var old_budget := budget(old)
		var migration_level: Dictionary = level.get("previous_versions",[level])[0]
		check(Packets.migrate(old,migration_level),"Old queue migration plans a solvable route: "+level.art_id)
		check(old.board==before.board and old.active==before.active and old.reservations==before.reservations,"Migration preserves live ants, board and active carriers")
		check(old_budget==budget(old),"Migration preserves every unlaunched capacity")
		check(not Packets.migrate(old,migration_level),"Queue migration is idempotent")
	var game = Fixture.create_game()
	root.add_child(game)
	await process_frame
	game.set_process(false)
	game.store.apply(func(s):s.story.opening=true;return true)
	game._start_level(8)
	for b in game.queue_buttons: check(b.focus_mode==Control.FOCUS_NONE,"Tap cannot leave a focus frame on a carrier")
	for col in game.puzzle.slot_count:
		if game.puzzle.can_deploy(col): game._deploy(col); break
	check(game.carrier_pose(0).open==0.0,"Platform work keeps rotors folded")
	var before_count: int = game.carrier_display_count(0)
	var event: Dictionary = game.puzzle.reserve()
	check(not event.is_empty(),"Real carrier can reserve a pixel")
	game.puzzle.pickup(int(event.id))
	check(game.carrier_display_count(0)==before_count-1,"Face counter removes picked pixels before they return home")
	# Restore before running a full real-flight solution, preserving controller bookkeeping.
	game._start_level(8)
	for value in game.current_level().solution:
		var guard := 0
		while game.busy and guard<5000:
			game._process(.1);guard+=1
		if int(value)<0:
			var col := -int(value)-1
			while game.queue_has_timer(col): game._process(.1)
		else: game._deploy(int(value))
	var guard := 0
	while game.screen=="play" and guard<15000:
		game._process(.1);guard+=1
	check(game.screen=="complete","Venus completes through real walking routes with large packets")
	check(not game.save_failed,"No checkpoint or stock save failure during the full real heist")
	check(HeistStyle.numeral_font().get_font_weight()==700,"Reference numerals use an actual static bold font")
	var cyan := AntSkin.texture(Color("78b5bc"))
	var coral := AntSkin.texture(Color("c98365"))
	check(cyan.get_height()>cyan.get_width(),"Scout uses the tall top-down silhouette")
	check(cyan.get_image().get_data()!=coral.get_image().get_data(),"Robot shell changes with carrier color")
	Fixture.cleanup(game)
	game.queue_free()
	await process_frame
	print("HEIST FEEDBACK CHECKS: %d | FAILURES: %d" % [checks,failures])
	quit(1 if failures else 0)
