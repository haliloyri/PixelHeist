extends Control
## S4 Story (design r13 sections 7 and 9). Chapter 0 is the one-panel opening; 1..19 show
## the chapter-complete card and chest, three comic panels, the fragment board on
## fragment chapters and the next chapter's name; 20 offers the three endings.
## Panels show painted comic art (panel.art -> assets/story/<art>.jpg); panels without art
## fall back to the location background.
const Kit = preload("res://scripts/ui/ui_kit.gd")
const L = preload("res://scripts/services/localization.gd")
const Art = preload("res://scripts/ui/pixel_art.gd")
const SPEAKERS := {"rocco": "Rocco", "sprocket": "Sprocket", "tuck": "Tuck", "quill": "Quill", "frost": "Mr. Frost", "glimmer": "Baron Glimmer"}
const SPEAKER_COLORS := {"rocco": Color("e0533d"), "sprocket": Color("3ba7f0"), "tuck": Color("7bc043"), "quill": Color("f2a93b"), "frost": Color("9b5de5"), "glimmer": Color("5a5a66")}
var game
var chapter_number := 0
var chapter: Dictionary = {}
var pages: Array = []
var page := 0
var content: Control
var ending := ""
var archive_mode := false
var archive_view:Control
var stage_scene_mode:=false
var stage_scene_finished:=false

## Home's Case File reuses S4 for unlocked panels only, with no rewards or progression.
func show_archive() -> void:
	archive_mode = true
	pages.clear()
	page = 0
	if content!=null:content.hide()
	if has_node("Skip"):get_node("Skip").hide()
	if has_node("StageScene"):
		var old_scene:=get_node("StageScene");remove_child(old_scene);old_scene.queue_free()
	archive_view=preload("res://scripts/ui/case_file.gd").new()
	archive_view.name="CaseFile";add_child(archive_view);archive_view.setup(game)

func setup(controller, number: int) -> void:
	game = controller
	chapter_number = number
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_STOP
	if number in [0,2]:
		stage_scene_mode=true
		var scene:=preload("res://scripts/ui/stage_story_scene.gd").new()
		scene.name="StageScene";add_child(scene)
		var scenes:Dictionary=preload("res://scripts/services/case_file_catalog.gd").SCENES.stage_first_commission
		scene.setup(game,game.campaign.stage_by_number(1),scenes.opening if number==0 else scenes.finale,"Start Heist" if number==0 else "Back to Safehouse",_finish_stage_scene,game._show_lobby if number==0 else _finish_stage_scene)
		return
	Kit.background(self, .6)
	content = Control.new()
	content.name = "Content"
	content.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(content)
	content.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	if number == 0:
		for panel in game.campaign.opening: pages.append({"kind": "panel", "panel": panel})
	else:
		chapter = game.campaign.chapter_by_number(number)
		pages.append({"kind": "complete"})
		if number == game.campaign.chapters.size():
			pages.append({"kind": "choice"})
		else:
			for panel in chapter.outro: pages.append({"kind": "panel", "panel": panel})
			if int(chapter.fragment) > 0: pages.append({"kind": "fragment"})
			pages.append({"kind": "next"})
	var skip := Kit.button(self, L.text("story.skip"), Rect2(560, 40, 130, 60), _skip, "secondary", 24)
	skip.name = "Skip"
	_show_page()

func _show_page() -> void:
	for child in content.get_children(): child.queue_free()
	var data: Dictionary = pages[page]
	match data.kind:
		"panel": _panel(data.panel, page == pages.size() - 1)
		"complete": _complete()
		"fragment": _fragment()
		"next": _next()
		"choice": _choice()
	get_node("Skip").visible = data.kind == "panel"

func _advance() -> void:
	if archive_mode:archive_view.next_scene();return
	if stage_scene_mode:_finish_stage_scene();return
	if page < pages.size() - 1:
		page += 1
		_show_page()
	else:
		if archive_mode: game._show_lobby()
		else: game._story_finished(chapter_number)

func _skip() -> void:
	if archive_mode:
		game._show_lobby()
		return
	if stage_scene_mode:_finish_stage_scene();return
	# Skip jumps past the panels; the chapter chest and the ending choice still wait.
	for i in range(page + 1, pages.size()):
		if pages[i].kind in ["choice", "next", "fragment"]:
			page = i
			_show_page()
			return
	game._story_finished(chapter_number)

func _panel(panel: Dictionary, last: bool) -> void:
	var frame := Kit.panel(content, Rect2(56, 150, 608, 760), Color("111018"), Kit.CREAM, 8, 12)
	frame.name = "Panel"
	frame.clip_contents = true
	var path := "res://assets/story/%s.jpg" % str(panel.art) if panel.has("art") else "res://assets/backgrounds/%s.png" % str(panel.background)
	var bg := Kit.image(frame, path, Rect2(0, 0, 608, 760))
	bg.name = "Art"
	bg.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	# Art keeps its top fifth and bottom edge clear: first bubble top-left, second bottom-right.
	var bubbles: Array = panel.bubbles
	for i in bubbles.size():
		var bubble: Dictionary = bubbles[i]
		var y: float = 20.0 if i == 0 else 760.0 - 20.0 - 130.0
		var box_x: float = 110.0 if i == 0 else 20.0
		var badge_x: float = 18.0 if i == 0 else 608.0 - 18.0 - 84.0
		var badge := Kit.panel(frame, Rect2(badge_x, y + 23, 84, 84), SPEAKER_COLORS.get(bubble.speaker, Kit.COPPER), Kit.INK, 5, 42)
		Kit.label(badge, str(SPEAKERS.get(bubble.speaker, bubble.speaker)).substr(0, 1), Rect2(0, 0, 84, 84), 42, Kit.CREAM, 6)
		var box := Kit.panel(frame, Rect2(box_x, y, 476, 130), Kit.CREAM, Kit.INK, 5, 30)
		box.name = "Bubble%d" % i
		Kit.label(box, SPEAKERS.get(bubble.speaker, bubble.speaker), Rect2(20, 8, 436, 30), 22, SPEAKER_COLORS.get(bubble.speaker, Kit.INK).darkened(.2), 0, HORIZONTAL_ALIGNMENT_LEFT)
		Kit.label(box, bubble.text, Rect2(20, 38, 436, 84), 30, Kit.INK, 0, HORIZONTAL_ALIGNMENT_LEFT, true)
	var hint := L.text("ui.continue") if last else L.text("story.next")
	Kit.button(content, hint, Rect2(200, 960, 320, 96), _advance, "green", 34).name = "Next"

func _complete() -> void:
	var stage: Dictionary = game.campaign.stage_for_level(chapter_number*5)
	Kit.ribbon(content,L.text("museum.stage_complete", {"n":stage.number}) if chapter_number%2==0 else L.text("museum.mid_stage"),Vector2(360,170),520,34)
	Kit.label(content, stage.title, Rect2(40, 230, 640, 60), 34, Kit.GOLD, 7)
	for i in chapter.heists.size():
		var frame := Kit.panel(content, Rect2(40 + i * 130, 320, 120, 120), Color("1b2133"), Color("e6b64c"), 5, 8)
		var art := Art.new()
		frame.add_child(art)
		art.position = Vector2(8, 8)
		art.size = Vector2(104, 104)
		art.level = game.level_for(chapter.heists[i])
		art.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var chest := Kit.image(content, "res://assets/lobby/chest_gems.png", Rect2(230, 480, 260, 250))
	chest.name = "Chest"
	if game.store.chapter_chest_ready(chapter):
		Kit.button(content, L.text("story.open_chest"), Rect2(200, 780, 320, 100), _open_chest, "green", 34).name = "OpenChest"
	else:
		Kit.button(content, L.text("story.next"), Rect2(200, 780, 320, 100), _advance, "green", 34).name = "Next"

func _open_chest() -> void:
	if archive_mode or stage_scene_mode:return
	var reward: Dictionary = game.store.claim_chapter_chest(chapter)
	_advance()
	if not reward.is_empty(): game._show_reward(reward)

func _fragment() -> void:
	Kit.ribbon(content, L.text("story.evidence"), Vector2(360, 200), 460, 34)
	var found: int = int(chapter.fragment)
	for i in 5:
		var slot := Kit.panel(content, Rect2(70 + i * 120, 330, 100, 130), Color("f1e2c0") if i < found else Color("3a2e26"), Kit.COPPER, 4, 10)
		Kit.label(slot, "✓" if i < found else "?", Rect2(0, 0, 100, 130), 48, Kit.INK if i < found else Kit.MUTED, 0)
	Kit.label(content, L.text("story.fragment", {"n": L.number(found)}), Rect2(40, 500, 640, 70), 40, Kit.GOLD, 7)
	Kit.button(content, L.text("story.next"), Rect2(200, 960, 320, 96), _advance, "green", 34).name = "Next"

func _next() -> void:
	var upcoming: Dictionary = game.campaign.stage_for_level(chapter_number*5+1)
	Kit.label(content,L.text("museum.next_stage",{"n":upcoming.number}) if chapter_number%2==0 else L.text("ui.level_badge",{"n":chapter_number*5+1}),Rect2(40,330,640,60),34,Kit.CREAM,6)
	Kit.label(content,upcoming.title,Rect2(40,400,640,90),42,Kit.GOLD,6)

	if not game.campaign.has_content(chapter_number + 1):
		Kit.label(content, L.text("story.coming_soon"), Rect2(40, 600, 640, 60), 30, Kit.CREAM, 6)
	Kit.button(content, L.text("ui.continue"), Rect2(200, 960, 320, 96), _advance, "green", 34).name = "Next"

func _choice() -> void:
	Kit.ribbon(content, L.text("story.choice"), Vector2(360, 150), 520, 32)
	var y := 240.0
	for id in game.campaign.endings:
		var info: Dictionary = game.campaign.endings[id]
		var card := Kit.panel(content, Rect2(60, y, 600, 230), Kit.WOOD, Kit.COPPER, 5, 24)
		Kit.label(card, info.title, Rect2(20, 16, 560, 50), 34, Kit.GOLD, 6)
		Kit.label(card, info.line, Rect2(30, 66, 540, 80), 22, Kit.CREAM, 4, HORIZONTAL_ALIGNMENT_CENTER, true)
		Kit.button(card, L.text("story.choose"), Rect2(200, 156, 200, 60), _choose.bind(id), "green", 26).name = "Choose_" + id
		y += 250

func _choose(id: String) -> void:
	if archive_mode or stage_scene_mode:return
	ending = id
	game.store.choose_ending(id)
	pages = pages.slice(0, page + 1)
	for panel in game.campaign.endings[id].panels: pages.append({"kind": "panel", "panel": panel})
	_advance()

func _finish_stage_scene()->void:
	if archive_mode or stage_scene_finished:return
	stage_scene_finished=true
	var reward:Dictionary={}
	if chapter_number==2:
		reward=game.store.claim_chapter_chest(game.campaign.chapter_by_number(2))
	game._story_finished(chapter_number)
	if not reward.is_empty():game._show_reward(reward)
