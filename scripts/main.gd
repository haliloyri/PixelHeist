extends Control
## Pixel Heist r13 controller (design docs/GameDesign.md, revision 2026-09-25-r13).
## Screens: S1 Safehouse ("lobby"), S2 Heist ("play"), S3 Level Complete ("complete"),
## S4 Story ("story"), S5 Gallery ("gallery"), S6 Shop ("shop"). Pop-ups P1-P7 live on
## the overlay. The heist simulation below is the unchanged puzzle/drone engine.

const CampaignCatalog = preload("res://scripts/services/campaign_catalog.gd")
const ProgressStore = preload("res://scripts/services/progress_store.gd")
const Commerce = preload("res://scripts/services/commerce.gd")
const HeistCheckpoint = preload("res://scripts/services/heist_checkpoint.gd")
const HeistIntro = preload("res://scripts/ui/heist_intro.gd")
const DepthHeist = preload("res://scripts/ui/depth_heist.gd")
const L = preload("res://scripts/services/localization.gd")
const Ambience = preload("res://scripts/core/ambience.gd")
const Routes = preload("res://scripts/core/drone_routes.gd")
const RowBeamFX = preload("res://scripts/ui/row_beam_fx.gd")
const QueueLayout = preload("res://scripts/ui/queue_layout.gd")
const Puzzle = preload("res://scripts/core/puzzle_state.gd")
const Backdrop = preload("res://scripts/ui/backdrop.gd")
const Art = preload("res://scripts/ui/pixel_art.gd")
const FlightLayer = preload("res://scripts/ui/flight_layer.gd")
const Kit = preload("res://scripts/ui/ui_kit.gd")
const LobbyScene = preload("res://scenes/ui/lobby.tscn")
const HeistScene = preload("res://scenes/ui/heist.tscn")
const LevelComplete = preload("res://scripts/ui/level_complete.gd")
const StoryScreen = preload("res://scripts/ui/story_screen.gd")
const GalleryScreen = preload("res://scripts/ui/gallery_screen.gd")
const MuseumIcon = preload("res://scripts/ui/museum_icon.gd")
const SettingsPanel = preload("res://scripts/ui/settings_panel.gd")
const RewardArt=preload("res://scripts/ui/reward_art.gd")
const MuseumControls=preload("res://scripts/ui/museum_controls.gd")
const RewardPanel = preload("res://scripts/ui/reward_panel.gd")
const ShopScreen = preload("res://scripts/ui/shop_screen.gd")

## Base simulation tempo (2026-09-23 doubled pace).
const BASE_TEMPO := 2.0
## 2026-09-26 (Halil): the speed toggle only affects the ants, and the ants' 1x pace is
## half of the old one. Ants move at BASE_TEMPO * ANT_TEMPO * speed; carriers, departures,
## decoy and queue timers keep the base tempo whatever the toggle says.
const ANT_TEMPO := 0.5
## Pickup haptic: a short soft tick, at most one per HAPTIC_GAP seconds.
const HAPTIC_MS := 14
const HAPTIC_GAP := .07
## Frame passages (2026-09-26): width in painting pixels, and how long the first ant
## pecks the rail (in ant time, 3 pecks) before the passage opens. Ants wait under the
## rail until the passage is at least GAP_PASSABLE open.
const GAP_TILES := 4.0 ## 3 on coarse boards (tile >= 18), see _layout_heist_frame()
const PECK_TIME := 1.0
const PECKS := 3
const GAP_PASSABLE := .6
const FIXED_STEP := 1.0 / 60.0
const DRONE_SPEED := 170.0
const PICKUP_LIFT_TIME := .55
const MAX_DRONES_PER_SLOT := 12
const MAX_DRONES := 36
const SPAWN_INTERVAL := .40
const DEPARTURE_TIME := 1.8
const DEPLOY_TIME := .38
const DECOY_TIME := 5.0
const FRAME_RECT := Rect2(29,82,662,516)
const FRAME_MARGIN := 26.0
const HEIST_FRAME_TOP_MIN := 128.0 ## Leave the shared progress count clear of every artwork frame.
## Frozen original geometry for next_pick() tie-breaks (see r12 notes): layout changes
## must never change which pixel a scout picks.
const ORIGIN_BOARD_POSITION := Vector2(98,104)
const ORIGIN_BOARD_SIZE := Vector2(524,470)
const ORIGIN_DOCK_Y := 784.0
const BOOSTERS := ["extra_dock", "zap", "scout_fly", "master_key", "row_beam"]
const HEIST_TOOLS := ["extra_dock", "row_beam", "zap"]
const BOOSTER_NAMES := {"extra_dock": "booster.extra_dock", "zap": "booster.zap", "scout_fly": "booster.scout_fly", "master_key": "booster.master_key", "row_beam": "booster.row_beam"}
const TIPS := {0: "tip.send", 1: "tip.mystery", 2: "tip.wait", 3: "tip.booster"}

var campaign = CampaignCatalog.new()
var store = ProgressStore.new()
var heist_checkpoint = HeistCheckpoint.new()
var commerce: Node
var all_levels: Array = []
var levels: Array = []
var artwork_details: Dictionary = {}
var puzzle = Puzzle.new()
var screen := "lobby"
var level_index := 0
var art_colors: Dictionary = {}
var speed := 1
var reduced_motion := false
var sound_enabled := true
var music_enabled := true
var vibration_enabled := true
var ambience: Node
var busy := false
var flights: Array = []
var beam_effects: Array = []
var pickup_effects: Array = []
var departures: Array = []
var deployments: Dictionary = {}
var rotor_ages: Dictionary = {}
var decoy_ages: Dictionary = {}
var queue_remaining: Array = [0.0, 0.0, 0.0]
var spawn_accumulator := 0.0
var pickup_count := 0
var pickup_players: Array[AudioStreamPlayer] = []
var clock_accumulator := 0.0
var modal_kind := ""
var ui: Control
var screen_view: Control
var overlay: Control
var toast_layer: Control
var backdrop: Control
var flight_layer: Control
var board_art: Control
var depth_view: Control
var sfx: AudioStreamPlayer
var queue_buttons: Array[Button] = []
var tool_buttons: Dictionary = {}
var queue_page := 0
var heist_layout: Dictionary = {}
var test_mode := false
var skip_heist_intro := false
var heist_intro: Control
var save_path := "user://progress.cfg"
var checkpoint_requested := false
var checkpoint_elapsed := 0.0
var app_suspended := false
var save_failed := false
var boosters_used := 0
var continues_used := 0
var ad_continue_used := false
var zap_mode := false
var zap_buttons: Array = []
var tip_label: Label
var last_win: Dictionary = {}
var story_chapter := 0
var capture_path := ""
var capture_timer := 0.0
var capture_done := false
var lobby_tab := ""
var lobby_clock := 0.0
## Bottom frame cuts (2026-09-26): x of the two passages, left and right of the title
## plaque, and how far each has been cut open (0..1; stays open for the heist).
var frame_gaps: Array = []
var gap_open: Array = [0.0, 0.0]
## Seconds (ant time) the first ant has pecked each passage; -1 = not started.
var gap_peck: Array = [-1.0, -1.0]
var haptic_clock := 0.0

# ------------------------------------------------------------------ setup

func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	all_levels = JSON.parse_string(FileAccess.get_file_as_string("res://data/levels.json"))
	levels = campaign.levels(all_levels)
	for detail in JSON.parse_string(FileAccess.get_file_as_string("res://data/artwork_details.json")):
		artwork_details[detail.art_id] = detail
	for arg in OS.get_cmdline_user_args():
		if arg == "--test-mode": test_mode = true
		if arg.begins_with("--capture="): capture_path = arg.trim_prefix("--capture=")
	# English only (design r13 section 16): never follow the device language.
	L.select("en")
	commerce = Commerce.new()
	commerce.name = "Commerce"
	add_child(commerce)
	commerce.purchase_finished.connect(_on_purchase)
	commerce.restore_finished.connect(_on_restore)
	commerce.rewarded_finished.connect(_on_rewarded)
	backdrop = Backdrop.new()
	add_child(backdrop)
	move_child(backdrop, 0)
	backdrop.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	backdrop.visible = false
	ui = get_node_or_null("Screens")
	if ui == null:
		ui = Control.new()
		ui.name = "Screens"
		add_child(ui)
	ui.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	ui.mouse_filter = Control.MOUSE_FILTER_IGNORE
	for child in ui.get_children(): child.queue_free()
	flight_layer = FlightLayer.new()
	flight_layer.game = self
	add_child(flight_layer)
	flight_layer.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	overlay = Control.new()
	overlay.name = "Overlay"
	add_child(overlay)
	overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	overlay.z_index = 50
	toast_layer = Control.new()
	toast_layer.z_index = 60
	add_child(toast_layer)
	toast_layer.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	toast_layer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_setup_audio()
	_open_store()
	if save_failed:
		_show_lobby()
		_show_modal("save_error")
	elif not test_mode and not store.state.story.opening:
		# First launch skips the Safehouse: one opening panel, then Heist 1.
		_show_story(0)
	else:
		_show_lobby()

func _open_store() -> void:
	store.open(save_path)
	save_failed = store.read_only
	var settings: Dictionary = store.state.settings
	sound_enabled = settings.sound
	music_enabled = settings.music
	vibration_enabled = settings.vibration
	reduced_motion = settings.reduced_motion

var resumed_level: Dictionary = {}
func current_level() -> Dictionary:
	return resumed_level if not resumed_level.is_empty() else levels[level_index]

func next_index() -> int:
	var art_id: String = store.next_art(campaign.order())
	for i in levels.size():
		if levels[i].art_id == art_id: return i
	return -1

func is_completed(index: int) -> bool:
	return index >= 0 and index < levels.size() and store.state.completed.has(levels[index].art_id)

func heist_number(index: int) -> int:
	return campaign.order().find(levels[index].art_id) + 1

func art_title(art_id: String) -> String:
	for level in all_levels:
		if level.art_id == art_id: return L.text(level.title)
	return str(campaign.artwork_images.get(art_id,{}).get("title",art_id))

func level_for(art_id: String) -> Dictionary:
	for level in levels:
		if level.art_id == art_id: return level
	return {}

func _setup_audio() -> void:
	ambience = Ambience.new()
	add_child(ambience)
	for index in 6:
		var voice := AudioStreamPlayer.new()
		voice.stream = load("res://assets/audio/pickup_%d.wav" % index)
		voice.max_polyphony = 16
		voice.volume_db = -10
		add_child(voice)
		pickup_players.append(voice)
	sfx = AudioStreamPlayer.new()
	add_child(sfx)
	sfx.volume_db = -12

func _sound(complete: bool = false) -> void:
	if not sound_enabled or test_mode: return
	sfx.stream = load("res://assets/audio/complete.wav" if complete else "res://assets/audio/pick.wav")
	sfx.play()

func _pickup_sound(id: int) -> void:
	pickup_count += 1
	if not sound_enabled or test_mode: return
	pickup_players[id % pickup_players.size()].play()

func _stop_sounds() -> void:
	for voice in pickup_players: voice.stop()
	if is_instance_valid(sfx): sfx.stop()

## Ant pace multiplier for the current toggle (see ANT_TEMPO).
func ant_tempo() -> float:
	return ANT_TEMPO * float(speed)

func _pickup_haptic() -> void:
	if not vibration_enabled or test_mode or haptic_clock < HAPTIC_GAP: return
	haptic_clock = 0.0
	Input.vibrate_handheld(HAPTIC_MS, .35)

func _vibrate() -> void:
	if vibration_enabled and not test_mode: Input.vibrate_handheld(40)

func _clear(node: Node) -> void:
	for child in node.get_children():
		node.remove_child(child)
		child.queue_free()

func toast(key: String, values: Dictionary = {}) -> void:
	_clear(toast_layer)
	var text: String = L.text(key, values) if L._source().has(key) else key
	var box := Kit.panel(toast_layer, Rect2(110, 1010, 500, 76), Color(0.08, 0.06, 0.05, .9), Kit.COPPER, 3, 34)
	Kit.label(box, text, Rect2(10, 4, 480, 68), 26, Kit.CREAM, 5)
	box.modulate.a = 0.0
	var tween := box.create_tween()
	tween.tween_property(box, "modulate:a", 1.0, .15)
	tween.tween_interval(1.4)
	tween.tween_property(box, "modulate:a", 0.0, .3)

# ------------------------------------------------------------------ screens

func _leave_heist() -> void:
	busy = false
	flights.clear()
	pickup_effects.clear()
	beam_effects.clear()
	departures.clear()
	deployments.clear()
	rotor_ages.clear()
	decoy_ages.clear()
	zap_mode = false
	_stop_sounds()
	if is_instance_valid(ambience): ambience.stop_all()

func _set_screen(name_: String, view: Control) -> void:
	heist_intro = null
	_close_modal()
	_clear(ui)
	queue_buttons.clear()
	tool_buttons.clear()
	board_art = null
	depth_view = null
	tip_label = null
	screen = name_
	screen_view = view
	ui.add_child(view)
	backdrop.visible = false
	flight_layer.queue_redraw()

func _show_lobby() -> void:
	_leave_heist()
	var view: Control = LobbyScene.instantiate()
	_set_screen("lobby", view)
	view.setup(self)

func _show_gallery(tab: String = "paintings") -> void:
	_leave_heist()
	var view := GalleryScreen.new()
	_set_screen("gallery", view)
	view.setup(self, tab)

func _show_shop() -> void:
	_leave_heist()
	var view := ShopScreen.new()
	_set_screen("shop", view)
	view.setup(self)

## chapter 0 = opening; 1..20 = that chapter's finale story.
func _show_story(chapter: int) -> void:
	_leave_heist()
	story_chapter = chapter
	var view := StoryScreen.new()
	_set_screen("story", view)
	view.setup(self, chapter)

func _story_finished(chapter: int) -> void:
	store.mark_story("opening" if chapter == 0 else campaign.chapter_by_number(chapter).id)
	if chapter == 0:
		var first := next_index()
		if first >= 0: _start_level(first)
		else: _show_lobby()
	else:
		_show_lobby()

func _show_complete() -> void:
	var view := LevelComplete.new()
	_leave_heist()
	_set_screen("complete", view)
	view.setup(self, last_win)

func _complete_continue() -> void:
	var art_id: String = str(last_win.get("art_id", ""))
	var chapter: Dictionary = campaign.chapter_of(art_id)
	var interstitial: bool = store.note_win_for_ads()
	if interstitial: commerce.show_interstitial()
	if campaign.is_finale(art_id) and last_win.get("first", false):
		_show_story(int(chapter.number))
	else:
		_show_lobby()

# ------------------------------------------------------------------ lobby actions

func _play() -> void:
	if save_failed: return
	var index := next_index()
	if index < 0:
		toast("lobby.coming_soon_heists")
		return
	var session: Dictionary = store.state.session
	if not session.is_empty() and session.get("art_id") == levels[index].art_id and heist_checkpoint.validate(session, levels).is_empty():
		_resume_heist(session)
		return
	if not store.has_energy():
		_show_modal("out_of_energy")
		return
	_start_level(index)

func _replay_artwork(art_id: String) -> void:
	if save_failed or not store.state.completed.has(art_id): return
	var index := -1
	for i in levels.size():
		if levels[i].art_id == art_id:
			index = i
			break
	if index < 0: return
	if not store.has_energy():
		_show_modal("out_of_energy")
		return
	_start_level(index)

func _open_daily() -> void:
	var reward: Dictionary = store.claim_daily()
	if reward.is_empty(): toast("chest.daily_wait")
	else: _show_reward(reward)
	_refresh_lobby()

func _open_star_chest() -> void:
	var reward: Dictionary = store.claim_star_chest()
	if reward.is_empty(): toast("chest.star_progress", {"stars": L.number(store.star_progress()), "total": L.number(int(store.rules.stars_per_chest))})
	else: _show_reward(reward)
	_refresh_lobby()

func _open_chapter_chest() -> void:
	for chapter in campaign.chapters:
		if store.chapter_chest_ready(chapter):
			_show_reward(store.claim_chapter_chest(chapter))
			_refresh_lobby()
			return
	toast("chest.chapter_progress")

func _watch_free_coins() -> void:
	if store.free_coins_left() <= 0:
		toast("ads.free_coins_done")
		return
	commerce.show_rewarded("free_coins")

func _refresh_lobby() -> void:
	if screen == "lobby" and is_instance_valid(screen_view) and screen_view.has_method("refresh"): screen_view.refresh()

func chapter_chest_count() -> int:
	var count := 0
	for chapter in campaign.chapters:
		if store.chapter_chest_ready(chapter): count += 1
	return count

func current_chapter_progress() -> Dictionary:
	var index := next_index()
	var art_id: String = levels[index].art_id if index >= 0 else campaign.order().back()
	var chapter: Dictionary = campaign.chapter_of(art_id)
	var done := 0
	for id in chapter.heists:
		if store.state.completed.has(id): done += 1
	return {"chapter": chapter, "done": done}

func current_stage_progress() -> Dictionary:
	var index := next_index()
	var number: int = campaign.level_number(levels[index].art_id) if index>=0 else mini(100,levels.size()+1)
	var stage: Dictionary = campaign.stage_for_level(number)
	return {"stage":stage,"done":campaign.stage_progress(int(stage.number),store.state.completed)}

func featured_offer() -> String:
	for id in ["starter_pack", "special_offer", "no_ads_pack"]:
		if store.product_available(id): return id
	return ""

# ------------------------------------------------------------------ heist

func _start_level(index: int) -> void:
	if save_failed or index < 0 or index >= levels.size(): return
	resumed_level = {}
	level_index = index
	art_colors.clear()
	for cell in current_level().cells:
		if int(cell) >= 0: art_colors[int(cell)] = true
	puzzle.setup(current_level())
	puzzle.establish_docks(5)
	queue_remaining.resize(puzzle.slot_count)
	queue_remaining.fill(float(current_level().queue_seconds))
	_leave_heist()
	boosters_used = 0
	continues_used = 0
	ad_continue_used = false
	motion_reset()
	_build_heist()
	_start_heist_intro()
	_save_session()

func _start_heist_intro() -> void:
	if skip_heist_intro: return
	var texture := HeistIntro.artwork_texture(current_level().art_id)
	# Legacy works without a licensed original retain their existing opening.
	if not texture: return
	_hide_tip()
	heist_intro = HeistIntro.new()
	screen_view.add_child(heist_intro)
	heist_intro.setup(self, texture)
	heist_intro.finished.connect(_finish_heist_intro)
	_refresh_play_hud()

func _finish_heist_intro() -> void:
	if not is_instance_valid(heist_intro): return
	heist_intro.queue_free()
	heist_intro = null
	_refresh_play_hud()
	_show_tip()

func intro_active() -> bool:
	return is_instance_valid(heist_intro)

func motion_reset() -> void:
	gap_open = [0.0, 0.0]
	gap_peck = [-1.0, -1.0]
	flights.clear()
	pickup_effects.clear()
	beam_effects.clear()
	departures.clear()
	deployments.clear()
	rotor_ages.clear()
	decoy_ages.clear()
	pickup_count = 0
	spawn_accumulator = 0
	clock_accumulator = 0
	busy = false

func _build_heist() -> void:
	queue_page = 0
	heist_layout = {}
	var view: Control = HeistScene.instantiate()
	_set_screen("play", view)
	backdrop.visible = true
	L.localize_tree(view)
	var transfer = view.get_node("TransferDisplay")
	transfer.game = self
	view.get_node("SpeedButton").pressed.connect(_toggle_speed)
	view.get_node("Speed3Button").pressed.connect(_select_speed3)
	view.get_node("PauseButton").pressed.connect(func(): _show_modal("pause"))
	view.get_node("MissionLabel").text = L.text("ui.level_badge", {"n": L.number(heist_number(level_index))})
	view.get_node("Background").location_index = level_index if level_index < 15 else 0
	view.get_node("Background").game = self
	view.get_node("AccessFrame").visible = true
	view.get_node("AccessFrame").game = self
	view.get_node("ArtifactTitle").text = L.text(current_level().title)
	L.fit(view.get_node("MissionLabel"), 25, 20)
	var tag: String = campaign.difficulty(current_level().art_id)
	if tag != "":
		var tag_label := Kit.label(view, tag, Rect2(260, 70, 200, 30), 20, Kit.RED if tag == "HARD" else Kit.PURPLE, 5)
		tag_label.name = "DifficultyTag"
	board_art = view.get_node("Artifact")
	board_art.level = current_level()
	board_art.cells = puzzle.board
	if current_level().has("heist_cell_pitch"):
		board_art.size = Vector2(puzzle.width,puzzle.height)*float(current_level().heist_cell_pitch)
		board_art.position = Vector2((720.0-board_art.size.x)*.5,float(current_level().heist_board_top))
	# Older boards keep their own size, but use the same HUD above the frame.
	board_art.position.y += maxf(0.0, HEIST_FRAME_TOP_MIN - frame_rect().position.y)
	board_art.queue_redraw()
	_layout_heist_frame()
	board_art.visible = false
	transfer.visible = false
	depth_view = DepthHeist.new()
	view.add_child(depth_view)
	view.move_child(depth_view, view.get_node("ProgressBacking").get_index())
	depth_view.setup(self)
	for column in 5:
		var button: Button = view.get_node("Queue%d" % column)
		button.visible = column < puzzle.slot_count
		if not button.visible: continue
		var rect := QueueLayout.front(column % 3, 3)
		button.position = rect.position
		button.size = rect.size
		button.pressed.connect(_deploy.bind(column))
		button.tooltip_text = L.text("queue.deploy")
		button.depth_rendered = true
		queue_buttons.append(button)
	for name_ in ["UndoButton", "SoundButton", "HelpButton"]:
		view.get_node(name_).visible = false
	for i in HEIST_TOOLS.size():
		var id: String = HEIST_TOOLS[i]
		var tool: Button = view.get_node("Tool%d" % i)
		tool.tooltip_text = "Recall" if id == "zap" else L.text(BOOSTER_NAMES[id])
		tool.pressed.connect(_use_booster.bind(id))
		tool_buttons[id] = tool
	if puzzle.slot_count > 3:
		var previous := Kit.button(view,"‹",Rect2(56,847,64,66),_change_queue_page.bind(-1),"secondary",34)
		previous.name = "PreviousQueues"
		previous.tooltip_text = "Previous queues"
		var next := Kit.button(view,"›",Rect2(600,847,64,66),_change_queue_page.bind(1),"secondary",34)
		next.name = "NextQueues"
		next.tooltip_text = "More queues"
		Kit.label(view,"1 / 2",Rect2(306,819,108,22),15,Color("f2e5ca"),2).name = "QueuePage"
	view.resized.connect(_resize_heist)
	_resize_heist()
	_show_tip()
	_refresh_play_hud()

func _layout_heist_frame() -> void:
	var frame := frame_rect()
	var gallery: Control = screen_view.get_node("ArtifactFrame")
	gallery.position = frame.position
	gallery.size = frame.size
	screen_view.get_node("AccessFrame").rect = frame
	var title: Label = screen_view.get_node("ArtifactTitle")
	var font: Font = title.get_theme_font("font")
	var text_width: float = font.get_string_size(title.text, HORIZONTAL_ALIGNMENT_LEFT, -1, 16).x
	var width: float = clampf(text_width + 48.0, 150.0, minf(frame.size.x - 56.0, 360.0))
	var plaque := Rect2(frame.get_center().x - width * .5, frame.position.y - 10.0, width, 32.0)
	title.add_theme_font_override("font",preload("res://assets/fonts/Lora-700.ttf"))
	title.add_theme_color_override("font_color",Color("24190f"))
	title.position = plaque.position
	title.size = plaque.size
	title.set_meta("text_bounds", Vector2(width - 24.0, plaque.size.y))
	# Two ant passages through the bottom rail, using the title's horizontal span
	# to space them evenly. The side and top rails are always sealed.
	var band: float = screen_view.get_node("ArtifactFrame").band
	var left_x: float = lerpf(frame.position.x + band * 1.4, plaque.position.x - 6.0, .5)
	var right_x: float = lerpf(plaque.end.x + 6.0, frame.end.x - band * 1.4, .5)
	frame_gaps = [left_x, right_x]
	screen_view.get_node("AccessFrame").gaps = frame_gaps
	# 3-5 painting pixels wide: 3 on coarse boards, 4 on fine ones, never more than half
	# of the rail piece it sits in.
	var tile: float = board_art.art_rect().size.x / float(puzzle.width)
	var piece: float = plaque.position.x - 6.0 - (frame.position.x + band * 1.4)
	screen_view.get_node("AccessFrame").cut_width = clampf(tile * (GAP_TILES if tile < 18.0 else 3.0), 8.0, piece * .5)
	var style := StyleBoxFlat.new()
	style.bg_color = Color("b89350")
	style.border_color = Color("7a4d12")
	style.set_border_width_all(3)
	style.set_corner_radius_all(9)
	style.shadow_color = Color(0, 0, 0, .35)
	style.shadow_size = 4
	style.shadow_offset = Vector2(0, 3)
	style.content_margin_left = 12
	style.content_margin_right = 12
	title.add_theme_stylebox_override("normal", style)
	L.fit(title, 18, 14)
	title.size = plaque.size
	var bar_y := 84.0
	screen_view.get_node("ProgressBacking").position = Vector2(266,bar_y)
	screen_view.get_node("ProgressBacking").size = Vector2(188,8)
	screen_view.get_node("ProgressTrack").position = Vector2(300,bar_y + 7.0)
	screen_view.get_node("ProgressFill").position = Vector2(300,bar_y + 7.0)
	screen_view.get_node("ProgressLabel").position = Vector2(250,bar_y + 12.0)
	screen_view.get_node("ProgressLabel").size = Vector2(220,22)
	screen_view.get_node("ProgressLabel").add_theme_font_size_override("font_size",16)
	screen_view.get_node("ProgressLabel").add_theme_font_override("font",preload("res://assets/fonts/Lora-700.ttf"))

func _refresh_play_hud() -> void:
	if screen != "play" or not is_instance_valid(screen_view): return
	screen_view.get_node("TransferDisplay").queue_redraw()
	screen_view.get_node("ProgressLabel").text = L.text("ui.progress", {"done": L.number(puzzle.total - puzzle.remaining), "total": L.number(puzzle.total)})
	var fill: ColorRect = screen_view.get_node("ProgressFill")
	fill.size.x = 120.0 * (1.0 - float(puzzle.remaining) / float(puzzle.total))
	fill.visible = puzzle.remaining < puzzle.total
	screen_view.get_node("StatusLabel").visible = false
	for column in puzzle.slot_count:
		var lane: Array = puzzle.lanes[column]
		var button = queue_buttons[column]
		button.visible = queue_column_visible(column)
		button.capacity = int(lane[0].amount) if not lane.is_empty() else 0
		button.time_fraction = float(queue_remaining[column]) / float(current_level().queue_seconds) if queue_has_timer(column) else -1.0
		if not lane.is_empty(): button.capsule_color = Color(current_level().palette[int(lane[0].color)])
		button.disabled = intro_active() or not puzzle.can_deploy(column)
		button.queue_redraw()
	for id in tool_buttons:
		tool_buttons[id].disabled = intro_active()
		tool_buttons[id].badge_count = store.booster_count(id)
		tool_buttons[id].tooltip_text = ("Recall" if id == "zap" else L.text(BOOSTER_NAMES[id])) + " · " + str(store.booster_count(id))
		tool_buttons[id].modulate = Color(1.3, 1.3, .8) if (id == "zap" and zap_mode) else Color.WHITE
	var speed_button = screen_view.get_node("SpeedButton")
	speed_button.multiplier = 1 if speed==3 else speed
	speed_button.highlighted = speed==2
	speed_button.disabled = intro_active()
	speed_button.queue_redraw()
	var speed3_button = screen_view.get_node("Speed3Button")
	speed3_button.multiplier = 3
	speed3_button.highlighted = speed==3
	speed3_button.seconds = store.speed3_remaining()
	speed3_button.tooltip_text = L.text("speed3.active", {"time":"%d:%02d" % [int(speed3_button.seconds)/60,int(speed3_button.seconds)%60]}) if speed3_button.seconds>0 else L.text("speed3.offer", {"gold":L.number(int(store.rules.speed3_gold))})
	speed3_button.disabled = intro_active()
	speed3_button.queue_redraw()
	if intro_active(): heist_intro._update_actors()

func _show_tip() -> void:
	var number := heist_number(level_index) - 1
	if not TIPS.has(number) or store.state.completed.size() > number: return
	tip_label = Kit.label(screen_view, L.text(TIPS[number]), Rect2(80, 545, 560, 56), 28, Kit.GOLD, 7)
	tip_label.name = "Tip"
	var hand := Kit.label(screen_view, "☝", Rect2(330, 930 if number != 3 else 1140, 60, 60), 44, Kit.CREAM, 6)
	hand.name = "TipHand"
	if not reduced_motion:
		var tween := hand.create_tween().set_loops()
		tween.tween_property(hand, "position:y", hand.position.y - 12, .45)
		tween.tween_property(hand, "position:y", hand.position.y, .45)

func _hide_tip() -> void:
	if not is_instance_valid(screen_view): return
	for name_ in ["Tip", "TipHand"]:
		var node := screen_view.get_node_or_null(name_)
		if node: node.queue_free()
	tip_label = null

func _deploy(column: int) -> void:
	if intro_active() or not modal_kind.is_empty() or screen != "play": return
	if zap_mode: return
	var slot: int = puzzle.deployment_slot(column)
	if not puzzle.deploy(column): return
	if heist_number(level_index) == 1: _hide_tip()
	deployments[int(puzzle.active[slot].order)] = {"age": 0.0, "column": column, "slot": slot}
	queue_remaining[column] = float(current_level().queue_seconds)
	queue_buttons[column].arrive()
	if puzzle.active[slot].get("decoy", false):
		decoy_ages[int(puzzle.active[slot].order)] = 0.0
	_sound()
	if not busy: spawn_accumulator = SPAWN_INTERVAL
	busy = true
	_refresh_play_hud()
	_save_session()

func _process(delta: float) -> void:
	if app_suspended or save_failed: return
	if screen == "play" and speed == 3 and store.speed3_remaining() == 0:
		speed = 2
		_save_session()
	if is_instance_valid(ambience):
		var active_count: int = puzzle.active.filter(func(c): return not c.is_empty()).size()
		ambience.update_mix(delta, screen == "play" and modal_kind.is_empty(), flights.size() + departures.size() + active_count, sound_enabled, music_enabled, test_mode)
	if not capture_path.is_empty() and not capture_done:
		capture_timer += delta
		if capture_timer > 1.0:
			capture_done = true
			_capture.call_deferred()
	lobby_clock += delta
	if lobby_clock >= 1.0:
		lobby_clock = 0.0
		if screen == "lobby" and is_instance_valid(screen_view) and screen_view.has_method("tick"): screen_view.tick()
		if modal_kind == "out_of_energy" and overlay.get_node_or_null("Card/Timer"):
			var seconds: int = store.seconds_to_next_energy()
			overlay.get_node("Card/Timer").text = L.text("energy.next", {"time": "%02d:%02d" % [seconds / 60, seconds % 60]})
	if screen != "play" or not modal_kind.is_empty(): return
	if intro_active():
		heist_intro.advance(minf(delta, .1))
		return
	_tick_beam_effects(minf(delta,.1))
	if screen != "play": return
	_tick_queue(minf(delta, .25) * BASE_TEMPO)
	var motion_delta: float = minf(delta, .25) * BASE_TEMPO
	if busy:
		clock_accumulator += motion_delta
		while clock_accumulator >= FIXED_STEP:
			clock_accumulator -= FIXED_STEP
			_motion_tick(FIXED_STEP)
			if not busy: break
	haptic_clock += delta
	_tick_gaps(delta)
	for effect in pickup_effects: effect.age = float(effect.age) + minf(delta, .1)
	pickup_effects = pickup_effects.filter(func(e): return float(e.age) < FlightLayer.EFFECT_TIME)
	if is_instance_valid(board_art): board_art.queue_redraw()
	if screen != "play": return
	_refresh_play_hud()
	flight_layer.queue_redraw()
	checkpoint_elapsed += delta
	if checkpoint_requested and checkpoint_elapsed >= 1.0: _save_session()

func _origin_dock(slot: int) -> Vector2:
	return Vector2(112 + slot * 124 if puzzle.slot_count == 5 else 200 + slot * 160, ORIGIN_DOCK_Y)

func _origin_board_rect() -> Rect2:
	var w := float(puzzle.width)
	var h := float(puzzle.height)
	var tile := minf(ORIGIN_BOARD_SIZE.x / w, ORIGIN_BOARD_SIZE.y / h)
	var extent := Vector2(w, h) * tile
	return Rect2(ORIGIN_BOARD_POSITION + (ORIGIN_BOARD_SIZE - extent) * 0.5, extent)

func frame_rect() -> Rect2:
	if not is_instance_valid(board_art) or board_art.level.is_empty(): return FRAME_RECT
	var area: Rect2 = board_art.art_rect()
	area.position += board_art.position
	return area.grow(FRAME_MARGIN)

func dock_position(slot: int) -> Vector2:
	return QueueLayout.dock(slot, puzzle.dock_count()) + heist_offset()

func carrier_radius() -> float:
	return QueueLayout.carrier_radius(puzzle.dock_count())

func carrier_pose(slot: int) -> Dictionary:
	var capsule: Dictionary = puzzle.active[slot]
	var pose := {"position": dock_position(slot), "open": 0.0}
	if capsule.is_empty(): return pose
	var order: int = capsule.order
	# Work on the platform with rotors folded; only departures unfold.
	pose.open = 0.0
	if deployments.has(order):
		var deploy: Dictionary = deployments[order]
		var age: float = deploy.age
		var start := QueueLayout.front(int(deploy.column), puzzle.slot_count).get_center() + heist_offset()
		pose.position = start.lerp(dock_position(slot), smoothstep(0, .38, age))
		pose.open = 0.0
	return pose

func queue_has_timer(column: int) -> bool:
	var lane: Array = puzzle.lanes[column]
	return float(current_level().queue_seconds) > 0 and not lane.is_empty() and not art_colors.has(int(lane[0].color))

func _tick_queue(dt: float) -> void:
	if float(current_level().queue_seconds) <= 0: return
	for column in puzzle.slot_count:
		if not queue_has_timer(column): continue
		queue_remaining[column] = maxf(0, float(queue_remaining[column]) - dt)
		if queue_remaining[column] <= 0:
			puzzle.expire_front(column)
			checkpoint_requested = true
			queue_buttons[column].arrive()
			queue_remaining[column] = float(current_level().queue_seconds)

func _motion_tick(dt: float) -> void:
	for order in rotor_ages.keys(): rotor_ages[order] = minf(.35, float(rotor_ages[order]) + dt)
	for slot in puzzle.dock_count():
		var cap: Dictionary = puzzle.active[slot]
		if cap.is_empty() or not cap.get("decoy", false): continue
		var order: int = cap.order
		decoy_ages[order] = float(decoy_ages.get(order, 0.0)) + dt
		if float(decoy_ages[order]) >= DECOY_TIME:
			puzzle.active[slot] = {}
			decoy_ages.erase(order)
			rotor_ages.erase(order)
			departures.append({"slot": slot, "color": cap.color, "position": dock_position(slot), "radius": carrier_radius(), "age": 0.0, "side": -1 if slot == 0 else 1})
	for order in deployments.keys():
		deployments[order].age = float(deployments[order].age) + dt
		if float(deployments[order].age) >= DEPLOY_TIME: deployments.erase(order)
	for departure in departures: departure.age = float(departure.age) + dt
	departures = departures.filter(func(d): return float(d.age) < DEPARTURE_TIME)
	var ant_dt: float = dt * ant_tempo()
	for i in gap_peck.size():
		if float(gap_peck[i]) < 0.0 or float(gap_open[i]) > 0.0: continue
		gap_peck[i] = float(gap_peck[i]) + ant_dt
		if float(gap_peck[i]) >= PECK_TIME: gap_open[i] = .001
	var done: Array = []
	for drone in flights:
		if _advance_drone(drone, ant_dt): done.append(drone)
	for drone in done: flights.erase(drone)
	spawn_accumulator = minf(spawn_accumulator + ant_dt, SPAWN_INTERVAL)
	while spawn_accumulator >= SPAWN_INTERVAL and flights.size() < MAX_DRONES:
		spawn_accumulator -= SPAWN_INTERVAL
		var excluded: Array = []
		for deploy in deployments.values(): excluded.append(int(deploy.slot))
		var area: Rect2 = board_art.art_rect()
		area.position += board_art.position
		var origin_area: Rect2 = _origin_board_rect()
		var origins: Array = []
		for slot in puzzle.dock_count(): origins.append((_origin_dock(slot) - origin_area.position) / (origin_area.size.x / puzzle.width))
		var event: Dictionary = puzzle.reserve(MAX_DRONES_PER_SLOT, excluded, origins)
		if event.is_empty():
			spawn_accumulator = 0
			break
		checkpoint_requested = true
		var dock := dock_position(int(event.slot))
		# 2026-09-26: ants leave and return through the door on the cube's player-facing
		# side, walking round the cube's flank to reach the painting.
		var door := QueueLayout.door(int(event.slot), puzzle.dock_count()) + heist_offset()
		var inside := QueueLayout.door_inside(int(event.slot), puzzle.dock_count()) + heist_offset()
		var flank_x := 0.0
		var route := {}
		var route_cost := INF
		# Compare both cube flanks and all permitted board entries, rather than
		# sending the whole fleet along one horizontal approach lane.
		for side in [-1.0,1.0]:
			var x: float = dock.x + side * QueueLayout.flank(puzzle.dock_count())
			var flank_top := Vector2(x, QueueLayout.flank_top(int(event.slot), puzzle.dock_count()) + heist_offset().y)
			var candidate := Routes.plan(puzzle, int(event.cell), area, frame_rect(), flank_top, flank_top, frame_gaps, float(screen_view.get_node("AccessFrame").cut_width))
			if candidate.is_empty(): continue
			var cost: float = Routes.path_length(candidate.outbound) + absf(x-door.x) + absf(door.y-flank_top.y)
			if cost < route_cost:
				route_cost = cost
				route = candidate
				flank_x = x
		if route.is_empty():
			puzzle.cancel_reservation(int(event.id))
			push_error("No safe route to accessible pixel %d" % int(event.cell))
			break
		var outbound: Array = [inside, door, Vector2(flank_x, door.y)]
		outbound.append_array(route.outbound)
		var inbound: Array = route.inbound.duplicate()
		inbound.append_array([Vector2(flank_x, door.y), door, inside])
		var carrier_order: int = puzzle.active[int(event.slot)].order
		if not rotor_ages.has(carrier_order): rotor_ages[carrier_order] = dt
		flights.append({"id": event.id, "cell": event.cell, "slot": event.slot, "color": event.color,
			"position": inside, "origin": inside, "path": outbound, "return_path": inbound, "target": route.target,
			"segment": 1, "phase": 0, "dwell": 0.0, "heading": PI / 2, "radius": 24.0, "carrier_order": carrier_order,
			"tile_size": area.size.x / puzzle.width, "walk_distance": 0.0})
		if route.has("gap"):
			flights[-1]["gap"] = int(route.gap)
			flights[-1]["gate"] = 3 + int(route.gate)
	if flights.is_empty() and departures.is_empty() and deployments.is_empty() and not puzzle.can_collect() and not puzzle.has_decoy(): _finish_motion()

func _advance_drone(drone: Dictionary, dt: float) -> bool:
	if float(drone.dwell) > 0:
		drone.dwell = maxf(0, float(drone.dwell) - dt)
		return false
	var budget := DRONE_SPEED * dt
	var path: Array = drone.path
	while int(drone.segment) < path.size():
		# Frame passage not cut yet: wait under the rail; the first ant there pecks it open.
		if int(drone.phase) == 0 and drone.has("gate") and int(drone.segment) == int(drone.gate):
			var gap: int = int(drone.gap)
			if float(gap_open[gap]) < GAP_PASSABLE:
				if float(gap_peck[gap]) < 0.0:
					gap_peck[gap] = 0.0
					drone["pecking"] = true
				return false
			drone.erase("pecking")
		var destination: Vector2 = path[int(drone.segment)]
		var direction: Vector2 = destination - Vector2(drone.position)
		var distance := direction.length()
		if distance > .01: drone.heading = direction.angle()
		if distance > budget:
			drone.walk_distance = float(drone.get("walk_distance",0.0))+budget
			drone.position = Vector2(drone.position) + direction.normalized() * budget
			return false
		drone.walk_distance = float(drone.get("walk_distance",0.0))+distance
		drone.position = destination
		budget -= distance
		drone.segment = int(drone.segment) + 1
	if int(drone.phase) == 0:
		if not puzzle.pickup(int(drone.id)):
			push_error("Duplicate or invalid pickup")
			return true
		checkpoint_requested = true
		_pickup_sound(int(drone.id))
		_pickup_haptic()
		pickup_effects.append({"position": drone.target, "color": drone.color, "cell": drone.cell, "age": 0.0, "seed": int(drone.id), "tile": float(drone.tile_size)})
		drone.phase = 1
		drone.path = drone.return_path
		drone.segment = 1
		drone.dwell = PICKUP_LIFT_TIME
		return false
	var delivered: Dictionary = puzzle.deliver(int(drone.id))
	checkpoint_requested = true
	if delivered.get("finished", false):
		rotor_ages.erase(int(drone.carrier_order))
		departures.append({"slot": drone.slot, "color": drone.color, "position": dock_position(int(drone.slot)), "radius": carrier_radius(), "age": 0.0, "side": -1 if int(drone.slot) == 0 or (int(drone.slot) == 1 and int(drone.carrier_order) % 2 == 0) else 1})
		_sound(true)
	return true

## Frame cuts open over ~0.35 s once the first ant heads for them, then stay open.
func _tick_gaps(delta: float) -> void:
	for i in gap_open.size():
		if float(gap_open[i]) > 0.0 and float(gap_open[i]) < 1.0:
			gap_open[i] = minf(1.0, float(gap_open[i]) + delta / .45)
	if is_instance_valid(screen_view) and screen_view.has_node("AccessFrame"):
		var access = screen_view.get_node("AccessFrame")
		access.open = gap_open
		access.peck = gap_peck
		access.queue_redraw()

func _recompute_busy() -> void:
	busy = not flights.is_empty() or not departures.is_empty() or not deployments.is_empty() or puzzle.can_collect() or puzzle.has_decoy()
	if busy and spawn_accumulator <= 0: spawn_accumulator = SPAWN_INTERVAL

func _finish_motion() -> void:
	busy = false
	spawn_accumulator = 0
	match puzzle.status():
		"won": _record_win()
		"blocked":
			_vibrate()
			_show_modal("out_of_space")
		"invalid": _show_modal("out_of_space")
	_refresh_play_hud()

func _record_win() -> void:
	if not beam_effects.is_empty(): return # Let the final cleared row dissolve before the reward screen.
	var art_id: String = current_level().art_id
	var stars: int = ProgressStore.stars_for(boosters_used, continues_used)
	var result: Dictionary = store.record_win(art_id, campaign.difficulty(art_id), stars)
	if result.is_empty():
		_save_error()
		return
	_sound(true)
	var chapter: Dictionary = campaign.chapter_of(art_id)
	last_win = result.duplicate()
	last_win.art_id = art_id
	last_win.crew = chapter.crew if campaign.is_finale(art_id) and result.first else ""
	last_win.difficulty = campaign.difficulty(art_id)
	last_win.double_used = false
	_show_complete()

func _save_session() -> void:
	checkpoint_requested = false
	checkpoint_elapsed = 0
	if screen != "play" or puzzle.board.is_empty(): return
	if not store.save_session(heist_checkpoint.capture(self)): _save_error()

func _resume_heist(job: Dictionary) -> void:
	var index := -1
	for i in levels.size():
		if levels[i].art_id == job.art_id: index = i
	if index < 0: return
	if not heist_checkpoint.validate(job, levels).is_empty(): return
	resumed_level = heist_checkpoint.catalog.matching_version(levels[index], str(job.content_hash))
	level_index = index
	art_colors.clear()
	for cell in current_level().cells:
		if int(cell) >= 0: art_colors[int(cell)] = true
	puzzle.setup(current_level())
	puzzle.restore(job.puzzle)
	var repacked: bool = preload("res://scripts/core/packet_queues.gd").migrate(puzzle,current_level())
	boosters_used = int(job.used)
	continues_used = int(job.continues)
	ad_continue_used = continues_used > 0
	motion_reset()
	var motion: Dictionary = job.motion
	flights = motion.get("flights", []).duplicate(true)
	clock_accumulator = float(motion.get("clock", 0))
	spawn_accumulator = float(motion.get("spawn", 0))
	pickup_count = int(motion.get("pickups", 0))
	deployments = motion.get("deployments", {}).duplicate(true)
	rotor_ages = motion.get("rotors", {}).duplicate()
	decoy_ages = motion.get("decoys", {}).duplicate()
	queue_remaining = motion.get("queue", queue_remaining).duplicate()
	if repacked: queue_remaining.fill(float(current_level().queue_seconds))
	speed = int(motion.get("speed", 1))
	if speed == 3 and store.speed3_remaining() == 0: speed = 2
	departures = motion.get("departures", []).duplicate(true)
	_build_heist()
	_reproject_motion(motion.get("layout",_legacy_heist_layout()),heist_layout)
	_hide_tip()
	# Ants were already on their way: the frame passages they use are already cut.
	if not flights.is_empty() or puzzle.remaining < puzzle.total:
		gap_open = [1.0, 1.0]
		gap_peck = [PECK_TIME, PECK_TIME]
	_recompute_busy()
	if job.modal != "": _show_modal(job.modal)
	elif not busy and puzzle.status() == "won": _record_win()
	elif not busy and puzzle.jammed(): _show_modal("out_of_space")

func _toggle_speed() -> void:
	if intro_active() or screen != "play" or not modal_kind.is_empty(): return
	speed = 2 if speed==1 else 1
	_refresh_play_hud()
	_save_session()

func _select_speed3() -> void:
	if intro_active() or screen != "play" or not modal_kind.is_empty(): return
	if store.speed3_remaining()>0:
		speed = 3
		_refresh_play_hud()
		_save_session()
	else:
		_show_modal("get_booster:speed3")

func _buy_speed3() -> void:
	if screen != "play" or store.speed3_remaining()>0: return
	if int(store.state.gold)<int(store.rules.speed3_gold):
		toast("shop.need_gold")
		return
	var previous := speed
	speed = 3
	if not store.unlock_speed3(heist_checkpoint.capture(self)):
		speed = previous
		_save_error()
		return
	_close_modal()
	_refresh_play_hud()

# ------------------------------------------------------------------ boosters

func _use_booster(id: String) -> void:
	if intro_active() or screen != "play" or not modal_kind.is_empty(): return
	if id == "zap" and zap_mode:
		_end_zap()
		return
	if store.booster_count(id) <= 0:
		_show_modal("get_booster:" + id)
		return
	match id:
		"row_beam":
			_fire_row_beam()
		"extra_dock":
			if not puzzle.add_dock():
				toast("booster.dock_max")
				return
			_after_dock_change()
			_spend_booster(id)
		"zap":
			var any := false
			for slot in puzzle.dock_count(): any = any or puzzle.can_zap(slot)
			if not any:
				toast("booster.zap_none")
				return
			_begin_zap()
		"scout_fly":
			if not puzzle.has_mystery():
				toast("booster.fly_none")
				return
			puzzle.reveal_mysteries()
			_spend_booster(id)
		"master_key":
			if not puzzle.can_use_key():
				toast("booster.key_none")
				return
			puzzle.arm_key()
			_spend_booster(id)
			toast("booster.key_armed")
	_refresh_play_hud()

func _spend_booster(id: String) -> void:
	boosters_used += 1
	_hide_tip()
	if not store.use_booster(id, heist_checkpoint.capture(self)): _save_error()

func _after_dock_change() -> void:
	_resize_heist()
	if is_instance_valid(depth_view): depth_view.refresh_docks()
	_recompute_busy()
	_refresh_play_hud()

func _begin_zap() -> void:
	zap_mode = true
	toast("booster.zap_pick")
	for slot in puzzle.dock_count():
		if not puzzle.can_zap(slot): continue
		var b := Button.new()
		b.flat = true
		b.name = "Zap%d" % slot
		var style := StyleBoxFlat.new()
		style.bg_color = Color(1, .85, .2, .18)
		style.border_color = Color("ffd23f")
		style.set_border_width_all(4)
		style.set_corner_radius_all(48)
		for state in ["normal", "hover", "pressed", "focus"]: b.add_theme_stylebox_override(state, style)
		screen_view.add_child(b)
		var r: float = carrier_radius()
		b.position = dock_position(slot) - Vector2(r, r)
		b.size = Vector2(r, r) * 2
		b.pressed.connect(_zap.bind(slot))
		zap_buttons.append(b)
	_refresh_play_hud()

func _end_zap() -> void:
	zap_mode = false
	for b in zap_buttons:
		if is_instance_valid(b): b.queue_free()
	zap_buttons.clear()
	_refresh_play_hud()

func zap_slot(slot: int) -> bool:
	if not puzzle.can_zap(slot): return false
	var order: int = int(puzzle.active[slot].order)
	if not puzzle.zap(slot): return false
	rotor_ages.erase(order)
	deployments.erase(order)
	return true

func _zap(slot: int) -> void:
	if not zap_slot(slot): return
	_end_zap()
	_spend_booster("zap")
	_recompute_busy()
	_refresh_play_hud()

## Out of Space "Continue": one more dock, or (at the dock cap) every idle carrier returns.
func _continue_heist() -> void:
	continues_used += 1
	if not puzzle.add_dock():
		for slot in puzzle.dock_count(): zap_slot(slot)
	_close_modal()
	_after_dock_change()
	_save_session()

func _continue_gold() -> void:
	var price: int = int(store.rules.continue_gold)
	if int(store.state.gold) < price:
		_show_shop_from_heist()
		return
	if not store.spend_gold(price, heist_checkpoint.capture(self)):
		_save_error()
		return
	_continue_heist()

func _continue_ad() -> void:
	if ad_continue_used: return
	commerce.show_rewarded("continue")

func _show_shop_from_heist() -> void:
	toast("shop.need_gold")

func _retry() -> void:
	if not store.spend_energy({}):
		_save_error()
		return
	if not store.has_energy():
		_show_lobby()
		_show_modal("out_of_energy")
		return
	_start_level(level_index)

func _quit_heist() -> void:
	if not store.spend_energy({}):
		_save_error()
		return
	_show_lobby()

# ------------------------------------------------------------------ commerce events

func buy_product(product_id: String) -> void:
	if not store.product_available(product_id):
		toast("shop.owned")
		return
	_show_modal("purchase_wait")
	commerce.purchase(product_id)

func _on_purchase(product_id: String, status: String, transaction_id: String) -> void:
	if modal_kind == "purchase_wait": _close_modal()
	match status:
		"success":
			if store.grant_purchase(product_id, transaction_id):
				var product: Dictionary = store.rules.products[product_id]
				_show_reward({"kind": "purchase", "product_id": product_id, "gold": int(product.get("gold", 0)), "title": product.name, "boosters": BOOSTERS if product.has("boosters") else []})
			else: _save_error()
		"pending": toast("shop.pending")
		"cancelled": toast("shop.cancelled")
		_: toast("shop.failed")
	_refresh_current()

func restore_purchases() -> void:
	commerce.restore()

func _on_restore(product_ids: Array) -> void:
	var count := 0
	for id in product_ids:
		if store.restore_entitlement(id): count += 1
	toast("shop.restored", {"count": L.number(count)})
	_refresh_current()

func _on_rewarded(placement: String, status: String, event_id: String) -> void:
	if status != "rewarded":
		toast("ads.unavailable" if status == "unavailable" else "ads.skipped")
		return
	match placement:
		"free_coins":
			var reward: Dictionary = store.grant_ad_reward("free_coins", event_id)
			if not reward.is_empty(): _show_reward(reward)
		"energy":
			if not store.grant_ad_reward("energy", event_id).is_empty():
				_close_modal()
				toast("energy.plus_one")
		"continue":
			if screen == "play" and not ad_continue_used:
				ad_continue_used = true
				store.grant_ad_reward("continue", event_id, heist_checkpoint.capture(self))
				_continue_heist()
		"double":
			if screen == "complete" and not last_win.get("double_used", false):
				var reward: Dictionary = store.grant_ad_reward("double:%d" % int(last_win.get("gold", 0)), event_id)
				if not reward.is_empty():
					last_win.double_used = true
					last_win.gold = int(last_win.gold) * 2
					if screen_view.has_method("refresh"): screen_view.refresh(last_win)
	_refresh_current()

func _refresh_current() -> void:
	if is_instance_valid(screen_view) and screen_view.has_method("refresh") and screen in ["lobby", "shop", "gallery"]: screen_view.refresh()

# ------------------------------------------------------------------ pop-ups

func _close_modal() -> void:
	modal_kind = ""
	if is_instance_valid(overlay):
		_clear(overlay)
		overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE

func _save_error() -> void:
	save_failed = true
	speed = 1
	if is_instance_valid(overlay) and modal_kind != "save_error": _show_modal("save_error")

func _retry_save() -> void:
	store.open(save_path)
	save_failed = store.read_only
	if not save_failed:
		_close_modal()
		_show_lobby()

func _show_reward(reward: Dictionary) -> void:
	if reward.is_empty(): return
	_show_modal("reward", reward)

func _show_modal(kind: String, data: Dictionary = {}) -> void:
	_close_modal()
	modal_kind = kind.get_slice(":", 0)
	overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	var card: Panel
	match modal_kind:
		"save_error":
			card = Kit.card(overlay, L.text("save.problem"), 460)
			Kit.label(card, L.text("save.short"), Rect2(40, 110, 520, 160), 28, Kit.CREAM, 5, HORIZONTAL_ALIGNMENT_CENTER, true)
			Kit.button(card, L.text("save.retry"), Rect2(150, 330, 300, 86), _retry_save, "primary")
		"pause", "settings":
			card = SettingsPanel.build(self,overlay,modal_kind=="pause")
		"out_of_space":
			card = Kit.card(overlay, L.text("oos.title"), 760)
			for i in 3:
				Kit.panel(card, Rect2(150 + i * 110, 110, 90, 90), Color("2c3450"), Kit.RED, 4, 18)
				Kit.label(card, "!", Rect2(150 + i * 110, 110, 90, 90), 44, Kit.RED, 5)
			Kit.label(card, L.text("oos.body"), Rect2(40, 220, 520, 60), 30, Kit.CREAM, 5)
			var price: int = int(store.rules.continue_gold)
			Kit.button(card, L.text("oos.continue", {"gold": L.number(price)}), Rect2(90, 310, 420, 96), _continue_gold, "green", 30)
			var ad := Kit.button(card, L.text("oos.watch_ad"), Rect2(90, 426, 420, 84), _continue_ad, "primary" if not ad_continue_used else "disabled", 28)
			ad.name = "WatchAd"
			Kit.button(card, L.text("ui.retry"), Rect2(90, 540, 200, 70), _retry, "secondary", 26)
			Kit.button(card, L.text("ui.home"), Rect2(310, 540, 200, 70), _quit_heist, "secondary", 26)
			Kit.label(card, L.text("energy.minus_one"), Rect2(90, 616, 420, 40), 22, Kit.MUTED, 4)
		"out_of_energy":
			card = Kit.card(overlay, L.text("energy.title"), 620, _close_modal)
			Kit.icon(card, "heart", Vector2(300, 170), 60).set("filled", false)
			var seconds: int = store.seconds_to_next_energy()
			var timer := Kit.label(card, L.text("energy.next", {"time": "%02d:%02d" % [seconds / 60, seconds % 60]}), Rect2(40, 250, 520, 60), 28, Kit.CREAM, 5)
			timer.name = "Timer"
			Kit.button(card, L.text("energy.refill", {"gold": L.number(int(store.rules.energy_refill_gold))}), Rect2(90, 340, 420, 92), _refill_energy, "green", 30)
			Kit.button(card, L.text("energy.watch_ad"), Rect2(90, 452, 420, 84), func(): commerce.show_rewarded("energy"), "primary", 28)
		"reward":
			card = RewardPanel.build(self,overlay,data)
		"offer":
			var id: String = str(data.get("product", featured_offer()))
			if id == "":
				_close_modal()
				toast("shop.owned")
				return
			var product: Dictionary = store.rules.products[id]
			card = MuseumControls.modal(overlay, product.name, 690, _close_modal)
			card.set_meta("product_id",id)
			RewardArt.attach(card,"no_ads" if id in ["no_ads","no_ads_pack"] else "offer",Rect2(190,104,260,260))
			var parts: Array = []
			if product.has("gold"): parts.append(L.text("offer.gold", {"gold": L.number(int(product.gold))}))
			if product.has("boosters"): parts.append(L.text("offer.boosters", {"count": L.number(int(product.boosters))}))
			if product.has("unlimited_energy_seconds"): parts.append(L.text("offer.energy"))
			if product.get("no_ads", false): parts.append(L.text("offer.no_ads"))
			if product.has("look"): parts.append(L.text("offer.look"))
			MuseumControls.label(card, "\n".join(parts), Rect2(40, 378, 560, 170), 24, Color("fff0cb"), HORIZONTAL_ALIGNMENT_CENTER, true)
			MuseumControls.button(card, product.price, Rect2(100, 578, 440, 80), buy_product.bind(id), true, 32)
		"get_booster":
			var id: String = kind.get_slice(":", 1)
			if id == "speed3":
				card = Kit.card(overlay, L.text("speed3.title"), 500, _close_modal)
				Kit.label(card, L.text("speed3.help"), Rect2(45,130,510,100), 28, Kit.CREAM, 5, HORIZONTAL_ALIGNMENT_CENTER, true)
				var speed_price: int = int(store.rules.speed3_gold)
				Kit.button(card, L.text("speed3.buy",{"gold":L.number(speed_price)}), Rect2(115,330,370,90), _buy_speed3, "green" if int(store.state.gold)>=speed_price else "disabled", 29)
			else:
				card = Kit.card(overlay, L.text(BOOSTER_NAMES[id]), 560, _close_modal)
				var tool_index: int = BOOSTERS.find(id)
				if tool_index < 4: Kit.image(card, ["res://assets/toolbar/tool_0_ant_plus.png", "res://assets/toolbar/tool_1_ray_gun.png", "res://assets/toolbar/tool_2_fly.png", "res://assets/toolbar/tool_3_key_blueprint.png"][tool_index], Rect2(220, 90, 160, 160))
				else:
					var icon := TextureRect.new()
					icon.texture = preload("res://scripts/ui/heist_skin.gd").icon(1)
					icon.position = Vector2(220,90); icon.size = Vector2(160,160)
					icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
					icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
					card.add_child(icon)
				Kit.label(card, L.text("booster.%s_help" % id), Rect2(40, 270, 520, 80), 26, Kit.CREAM, 5, HORIZONTAL_ALIGNMENT_CENTER, true)
				var price: int = int(store.rules.booster_price)
				Kit.button(card, L.text("booster.buy", {"gold": L.number(price)}), Rect2(130, 390, 340, 92), _buy_booster.bind(id), "green" if int(store.state.gold) >= price else "disabled", 30)
		"painting":
			var art_id: String = str(data.art_id)
			var has_board: bool = not level_for(art_id).is_empty()
			var pixels: bool = bool(data.get("pixels",false)) and has_board
			var owned: bool = store.state.completed.has(art_id)
			card = Kit.card(overlay, art_title(art_id), 1000 if has_board else 870, _close_modal)
			card.add_theme_stylebox_override("panel",Kit.panel_style(Color("0b1924"),Color("c6a16a"),5,28))
			_style_museum_modal_button(card.get_node("Close"),false)
			MuseumIcon.attach(card.get_node("Close"),"close","Close artwork",false,true)
			var inner:Panel=card.get_node("Inner")
			inner.add_theme_stylebox_override("panel",Kit.panel_style(Color("102735"),Color("547468"),2,22))
			var art := preload("res://scripts/ui/museum_art.gd").new()
			art.name="Artwork"
			card.add_child(art)
			art.position = Vector2(55, 94)
			art.setup(self,art_id,pixels,Vector2(490,460),false)
			card.set_meta("pixels",pixels)
			if has_board:
				_museum_modal_button(card,"original" if pixels else "pixels",Rect2(225,570,150,60),func():_toggle_painting_view_in_place(card,art_id),L.text("museum.show_originals" if pixels else "museum.show_pixels"),pixels).name="ViewMode"
			var detail: Dictionary = artwork_details.get(art_id, {})
			if not detail.is_empty():
				Kit.label(card, "%s · %s" % [L.text(detail.artist), L.text(detail.date)], Rect2(30, 646, 540, 45), 24, Kit.GOLD, 4)
				var fact: String = L.text(detail.facts[0]) if detail.get("facts", []).size() > 0 else L.text(detail.description)
				Kit.label(card, fact, Rect2(40, 696, 520, 130), 22, Kit.CREAM, 3, HORIZONTAL_ALIGNMENT_CENTER, true)
			else:
				var record: Dictionary = campaign.artwork_images.get(art_id,{})
				Kit.label(card,"%s · %s" % [record.get("artist",""),record.get("date","")],Rect2(30,585,540,80),24,Kit.GOLD,3,HORIZONTAL_ALIGNMENT_CENTER,true)
				Kit.label(card,str(record.get("institution","")),Rect2(40,680,520,60),22,Kit.CREAM,2,HORIZONTAL_ALIGNMENT_CENTER,true)
			if owned:
				var selected: bool = store.collection().art_ids.has(art_id)
				_museum_modal_button(card,"remove" if selected else "add",Rect2(100,840,180,66),func():
					if not store.toggle_collection(art_id):toast("museum.collection_full" if store.collection().art_ids.size()>=10 else "museum.save_failed")
					else:_show_modal("painting",{"art_id":art_id,"pixels":bool(card.get_meta("pixels"))});_refresh_current(),L.text("museum.remove_collection" if selected else "museum.add_collection"),not selected).name="Collection"
				_museum_modal_button(card,"collection",Rect2(320,840,180,66),func():_close_modal();_show_gallery("collection"),L.text("museum.open_collection"))
				if has_board:
					var replay:=Kit.button(card,L.text("ui.replay"),Rect2(100,920,400,62),_replay_artwork.bind(art_id),"green",26)
					replay.name="Replay"
					_style_museum_modal_button(replay,true)
			else:
				var badge:=Kit.panel(card,Rect2(274,790 if not has_board else 850,52,52),Color("0b1924"),Color("c6a16a"),2,26)
				Kit.icon(badge,"lock",Vector2(26,26),18)

		"purchase_wait":
			card = Kit.card(overlay, L.text("shop.processing"), 360)
			Kit.label(card, "…", Rect2(40, 120, 520, 120), 60, Kit.GOLD, 6)
		"story_ending":
			pass
	if is_instance_valid(card):
		card.pivot_offset = card.size * .5
		if not reduced_motion:
			card.scale = Vector2(.9, .9)
			card.create_tween().tween_property(card, "scale", Vector2.ONE, .18).set_trans(Tween.TRANS_BACK)
	if modal_kind == "pause": _save_session()

func _museum_modal_button(parent:Control,kind:String,rect:Rect2,action:Callable,label:String,selected:=false)->Button:
	var button:=Kit.button(parent,"",rect,action,"secondary",22)
	_style_museum_modal_button(button,selected)
	return MuseumIcon.attach(button,kind,label,selected,true)

func _style_museum_modal_button(button:Button,selected:bool)->void:
	preload("res://scripts/ui/museum_controls.gd").style(button,selected)

func _toggle_painting_view_in_place(card:Panel,art_id:String)->void:
	if modal_kind!="painting" or not is_instance_valid(card) or not card.is_inside_tree():return
	var art:Control=card.get_node("Artwork")
	var button:Button=card.get_node("ViewMode")
	var pixels:bool=not bool(card.get_meta("pixels"))
	art.setup(self,art_id,pixels,Vector2(490,460),false)
	card.set_meta("pixels",pixels)
	_style_museum_modal_button(button,pixels)
	var label:String=L.text("museum.show_originals" if pixels else "museum.show_pixels")
	button.tooltip_text=label
	button.set_meta("accessible_label",label)
	var icon:Control=button.get_node("Icon")
	icon.set("kind","original" if pixels else "pixels")
	icon.set("selected",pixels)
	icon.queue_redraw()

func _toggle_setting(key: String) -> void:
	if not key in ["sound","music","vibration","reduced_motion"]:return
	var value:bool=not bool(store.state.settings[key])
	if store.set_setting(key,value):
		sound_enabled=store.state.settings.sound
		music_enabled=store.state.settings.music
		vibration_enabled=store.state.settings.vibration
		reduced_motion=store.state.settings.reduced_motion
		if not sound_enabled:
			_stop_sounds()
			ambience.stop_all()
	else:toast("museum.save_failed")
	var card:=overlay.get_node_or_null("Card")
	if card is Panel and modal_kind in ["settings","pause"]:
		SettingsPanel.refresh(card,store.state.settings)

func _refill_energy() -> void:
	if int(store.state.gold) < int(store.rules.energy_refill_gold):
		toast("shop.need_gold")
		return
	if store.refill_energy_gold():
		_close_modal()
		toast("energy.full")
		_refresh_lobby()

func _buy_booster(id: String) -> void:
	if store.buy_booster(id):
		_close_modal()
		toast("booster.bought", {"name": L.text(BOOSTER_NAMES[id])})
		_refresh_play_hud()
	else:
		toast("shop.need_gold")

func _share(art_id: String) -> void:
	var text: String = L.text("share.text", {"title": art_title(art_id)})
	DisplayServer.clipboard_set(text)
	toast("share.copied")

func open_painting(art_id: String) -> void:
	# A catalogued original is a preview, never an unlock or a collection grant.
	if campaign.level_number(art_id)==0 or HeistIntro.artwork_texture(art_id)==null:return
	_show_modal("painting", {"art_id": art_id})

# ------------------------------------------------------------------ system

func _notification(what: int) -> void:
	if what == NOTIFICATION_APPLICATION_PAUSED or what == NOTIFICATION_APPLICATION_FOCUS_OUT:
		app_suspended = true
		if screen == "play": _save_session()
		if is_instance_valid(ambience): ambience.stop_all()
		_stop_sounds()
	elif what == NOTIFICATION_APPLICATION_RESUMED or what == NOTIFICATION_APPLICATION_FOCUS_IN:
		app_suspended = false
	elif what == NOTIFICATION_WM_CLOSE_REQUEST:
		if screen == "play": _save_session()

func _unhandled_key_input(event: InputEvent) -> void:
	if not event is InputEventKey or not event.pressed or event.echo: return
	if event.keycode == KEY_ESCAPE:
		if modal_kind in ["settings", "offer", "get_booster", "painting", "out_of_energy", "reward"]: _close_modal()
		elif modal_kind == "pause": _close_modal()
		elif modal_kind.is_empty() and screen == "play": _show_modal("pause")
		elif modal_kind.is_empty() and screen == "gallery": screen_view._back()
		elif modal_kind.is_empty() and screen == "shop": _show_lobby()
		elif modal_kind.is_empty() and screen == "story" and screen_view.archive_mode: screen_view.archive_view._back()
		get_viewport().set_input_as_handled()
	elif screen == "play" and modal_kind.is_empty():
		match event.keycode:
			KEY_1: _deploy(0)
			KEY_2: _deploy(1)
			KEY_3: _deploy(2)
			KEY_4: _deploy(3)
			KEY_5: _deploy(4)

func _capture() -> void:
	await RenderingServer.frame_post_draw
	var image := get_viewport().get_texture().get_image()
	var result := image.save_png(capture_path)
	print("CAPTURE ", capture_path, " status=", result)
	get_tree().quit()

func queue_column_visible(column: int) -> bool:
	return column / 3 == queue_page

func _change_queue_page(direction: int) -> void:
	if intro_active(): return
	queue_page = posmod(queue_page+direction,ceili(puzzle.slot_count/3.0))
	_refresh_play_hud()
	var label := screen_view.get_node_or_null("QueuePage")
	if label: label.text = "%d / %d" % [queue_page+1,ceili(puzzle.slot_count/3.0)]

func _fire_row_beam() -> void:
	if not puzzle.can_beam():
		toast("booster.beam_busy")
		return
	var row: int = puzzle.beam_row()
	var visuals := {}
	for cell in range(row*puzzle.width,(row+1)*puzzle.width):
		if int(puzzle.board[cell]) < 0: continue
		var color := int(puzzle.board[cell])
		visuals[cell] = {"cell":cell,"color":color,"age":0.0,"delay":float(cell%puzzle.width)*.009,"reduced":reduced_motion,"target":_beam_target(color,board_art.visual_cell_position(cell).x)}
	var fronts: Array = []
	for lane in puzzle.lanes: fronts.append(lane.front().duplicate() if not lane.is_empty() else {})
	var removed: Array = puzzle.clear_beam_row()
	for column in puzzle.slot_count:
		var lane: Array = puzzle.lanes[column]
		if lane.is_empty() or lane.front() != fronts[column]: queue_remaining[column] = float(current_level().queue_seconds)
	if removed.is_empty(): return
	pickup_count += removed.size()
	# Remove presentation references only for carriers retired by this transaction.
	var orders := {}
	for cap in puzzle.active:
		if not cap.is_empty(): orders[int(cap.order)] = true
	for dict in [deployments,rotor_ages]:
		for order in dict.keys():
			if not orders.has(order): dict.erase(order)
	for cell in removed: beam_effects.append(visuals[cell])
	_spend_booster("row_beam")
	_recompute_busy()
	_refresh_play_hud()
	if puzzle.remaining == 0 and flights.is_empty(): _record_win()

## Anchor carriers/queues to the compact footer. Extra portrait height becomes ant space.
func heist_offset() -> Vector2:
	return Vector2(0,maxf(0,size.y-1280))

func _current_heist_layout() -> Dictionary:
	var area: Rect2 = board_art.art_rect()
	area.position += board_art.position
	var origins: Array = []
	for slot in puzzle.dock_count(): origins.append(QueueLayout.door_inside(slot,puzzle.dock_count())+heist_offset())
	return {"board":area,"origins":origins}

func _legacy_heist_layout() -> Dictionary:
	var extent := Vector2(puzzle.width,puzzle.height)*minf(428.0/puzzle.width,376.0/puzzle.height)
	var origins: Array = []
	var count: int = puzzle.dock_count()
	var scale_: float = .44 if count >= 5 else .48
	var y := 752.0-100.0*(.23+.35*scale_)*sin(.22)+150.0*scale_*215.0/256.0*.3
	for slot in count: origins.append(Vector2(360+(slot-(count-1)*.5)*(100 if count>=5 else 104),y))
	return {"board":Rect2(Vector2(146,112)+(Vector2(428,376)-extent)*.5,extent),"origins":origins}

func _map_motion_point(point: Vector2, old: Dictionary, next: Dictionary, slot: int) -> Vector2:
	var a: Rect2 = old.board
	var b: Rect2 = next.board
	var old_origin: Vector2 = old.origins[mini(slot,old.origins.size()-1)]
	var origin: Vector2 = next.origins[mini(slot,next.origins.size()-1)]
	var blend := clampf((point.y-a.end.y)/maxf(1,old_origin.y-a.end.y),0,1)
	var board_point := b.position+(point-a.position)*b.size/a.size
	var dock_point := point+origin-old_origin
	return board_point.lerp(dock_point,blend)

func _reproject_motion(old: Dictionary, next: Dictionary) -> void:
	if old.is_empty() or old == next: return
	for drone in flights:
		for key in ["position","origin","target"]: drone[key] = _map_motion_point(drone[key],old,next,int(drone.slot))
		for key in ["path","return_path"]:
			for i in drone[key].size(): drone[key][i] = _map_motion_point(drone[key][i],old,next,int(drone.slot))
		drone.tile_size = next.board.size.x/puzzle.width
	for d in departures: d.position = _map_motion_point(d.position,old,next,int(d.slot))

func _resize_heist() -> void:
	if screen != "play" or not is_instance_valid(board_art) or queue_buttons.size() != puzzle.slot_count: return
	var next := _current_heist_layout()
	_reproject_motion(heist_layout,next)
	heist_layout = next
	for column in queue_buttons.size(): queue_buttons[column].position = QueueLayout.front(column,3).position+heist_offset()
	for node_name in ["PreviousQueues","NextQueues","QueuePage"]:
		var node := screen_view.get_node_or_null(node_name)
		if node: node.position.y = (819 if node_name == "QueuePage" else 847)+heist_offset().y
	if is_instance_valid(depth_view) and is_instance_valid(depth_view.actors): depth_view.actors.size.y = 1178+heist_offset().y
	if zap_mode:
		_end_zap()
		_begin_zap()

## Pixels already carried homeward have left the painting, so the face counter excludes them.
func carrier_display_count(slot: int) -> int:
	if slot < 0 or slot >= puzzle.active.size() or puzzle.active[slot].is_empty(): return 0
	var count := int(puzzle.active[slot].left)
	for reservation in puzzle.reservations.values():
		if int(reservation.slot) == slot and reservation.picked: count -= 1
	return maxi(0,count)

func _beam_target(color: int, from_x: float) -> Dictionary:
	var best := {"kind":"dock","index":0}
	var score := INF
	for slot in puzzle.dock_count():
		var cap: Dictionary = puzzle.active[slot]
		if cap.is_empty(): continue
		var candidate := absf(dock_position(slot).x-from_x)+(0 if int(cap.color)==color else 1000)
		if candidate < score: score=candidate; best={"kind":"dock","index":slot}
	if score < INF: return best
	for column in puzzle.slot_count:
		if not queue_column_visible(column) or puzzle.lanes[column].is_empty(): continue
		var candidate := absf(QueueLayout.row(column,3,0).x-from_x)+(0 if int(puzzle.lanes[column][0].color)==color else 1000)
		if candidate < score: score=candidate; best={"kind":"queue","index":column}
	return best

func beam_target_position(target: Dictionary) -> Vector2:
	if target.kind == "dock": return dock_position(mini(int(target.index),puzzle.dock_count()-1))
	return QueueLayout.row(int(target.index),3,0)+heist_offset()

func _tick_beam_effects(delta: float) -> void:
	if beam_effects.is_empty(): return
	for effect in beam_effects: effect.age = float(effect.age)+delta
	beam_effects = beam_effects.filter(func(e): return float(e.age)<RowBeamFX.lifetime(e))
	if beam_effects.is_empty() and puzzle.remaining==0 and flights.is_empty(): _record_win()
