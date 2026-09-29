extends Control
## Presentation only: ten scout bees reveal the existing, unchanged puzzle.
signal finished
const BODY = preload("res://assets/heist_intro/red_bee_topdown.png")
const QueueLayout = preload("res://scripts/ui/queue_layout.gd")
const BEE_COUNT := 10
const ARRIVAL_START := .8
const RELEASE_START := 1.8
const SCAN_START := 2.85
const SCAN_END := 5.05
const DEPARTURE_START := 6.3
const DEPARTURE_END := 7.8
const DURATION := 8.3
const HATCH_OFFSET := Vector2(0, 46)
var game: Control
var original: Texture2D
var elapsed := 0.0
var done := false
var reduced := false

static func artwork_texture(art_id: String) -> Texture2D:
	var records = JSON.parse_string(FileAccess.get_file_as_string("res://data/artwork_images.json"))
	if not records is Dictionary or not records.has(art_id): return null
	var path: String = records[art_id].get("path", "")
	if path.is_empty() or not ResourceLoader.exists(path): return null
	return load(path) as Texture2D

func setup(owner_game: Control, texture: Texture2D) -> void:
	game = owner_game
	original = texture
	reduced = game.reduced_motion
	name = "HeistIntro"
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	z_index = 12
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_update_actors()

func advance(delta: float) -> void:
	if done: return
	if game.reduced_motion and not reduced:
		reduced = true
		elapsed = minf(elapsed, .6)
	elapsed += maxf(delta, 0.0)
	_update_actors()
	queue_redraw()
	if elapsed >= duration():
		done = true
		finished.emit()

func duration() -> float:
	return 1.4 if reduced else DURATION

func actor_alpha() -> float:
	if elapsed >= duration(): return 1.0
	return clampf((elapsed - (1.1 if reduced else DEPARTURE_END)) / (.3 if reduced else .4), 0.0, 1.0)

func phase() -> String:
	if done: return "complete"
	if reduced: return "crossfade"
	if elapsed < ARRIVAL_START: return "original"
	if elapsed < RELEASE_START: return "arrival"
	if elapsed < SCAN_START: return "release"
	if elapsed < SCAN_END: return "conversion"
	if elapsed < DEPARTURE_START: return "return"
	if elapsed < DEPARTURE_END: return "departure"
	return "queues"

func carrier_position(at: float) -> Vector2:
	var home: Vector2 = QueueLayout.front(1, 3).get_center() + game.heist_offset()
	var arrival := _ease(clampf((at - ARRIVAL_START) / (RELEASE_START - ARRIVAL_START), 0, 1))
	var departure := _ease(clampf((at - DEPARTURE_START) / (DEPARTURE_END - DEPARTURE_START), 0, 1))
	return Vector2(home.x, game.size.y + 180).lerp(home, arrival).lerp(Vector2(home.x, -180), departure)

func scout_release(index: int, at: float) -> float:
	return clampf((at - RELEASE_START - index * .045) / .6, 0, 1)

func scout_return(index: int, at: float) -> float:
	return clampf((at - SCAN_END - index * .045) / .75, 0, 1)

func scouts_outside(at: float) -> int:
	var count := 0
	for i in BEE_COUNT:
		if scout_release(i, at) > 0 and scout_return(i, at) < 1: count += 1
	return count

func _update_actors() -> void:
	if is_instance_valid(game.depth_view) and is_instance_valid(game.depth_view.actors):
		game.depth_view.actors.modulate.a = actor_alpha()
	for button in game.queue_buttons: button.modulate.a = actor_alpha()
	for id in game.tool_buttons: game.tool_buttons[id].modulate.a = actor_alpha()
	for node_name in ["PreviousQueues", "NextQueues", "QueuePage", "ProgressLabel", "ProgressBacking"]:
		var node = game.screen_view.get_node_or_null(node_name)
		if node: node.modulate.a = actor_alpha()

func board_rect() -> Rect2:
	var rect: Rect2 = game.board_art.visual_rect()
	rect.position += game.board_art.position
	return rect

func _draw() -> void:
	if not is_instance_valid(game) or not original or done: return
	var rect := board_rect()
	var conversion := clampf((elapsed - SCAN_START) / (SCAN_END - SCAN_START), 0.0, 1.0)
	if reduced:
		draw_texture_rect(original, rect, false, Color(1, 1, 1, 1.0 - clampf((elapsed - .6) / .5, 0, 1)))
		return
	# Reveal complete pixel rows. Source pixels and the live board share one rectangle.
	var rows: int = game.current_level().height
	var cut := floorf(conversion * rows) / rows
	if cut < 1.0:
		var target := Rect2(rect.position + Vector2(0, rect.size.y * cut), Vector2(rect.size.x, rect.size.y * (1.0 - cut)))
		var source := Rect2(Vector2(0, original.get_height() * cut), Vector2(original.get_width(), original.get_height() * (1.0 - cut)))
		draw_texture_rect_region(original, target, source)
	if elapsed < ARRIVAL_START or elapsed >= DEPARTURE_END: return
	var mother := carrier_position(elapsed)
	var hatch := mother + HATCH_OFFSET
	_bee(mother, 260, elapsed * 40)
	for i in BEE_COUNT:
		var release := scout_release(i, elapsed)
		var returning := scout_return(i, elapsed)
		if release <= 0 or returning >= 1: continue
		var x := rect.position.x + rect.size.x * (i + .5) / BEE_COUNT
		var target := Vector2(x, rect.position.y + conversion * rect.size.y)
		var station := target + Vector2(0, -55)
		var scout := hatch.lerp(station, _ease(release))
		var facing := (station - hatch).angle() + PI / 2
		if elapsed >= SCAN_END:
			scout = station.lerp(hatch, _ease(returning))
			# Turn before returning to the same visible hangar opening.
			facing = lerp_angle(facing, (hatch - station).angle() + PI / 2, clampf((elapsed - SCAN_END) / .15, 0, 1))
		elif elapsed >= SCAN_START:
			facing = 0.0
		if elapsed >= SCAN_START and elapsed < SCAN_END:
			var origin := scout + Vector2(0, 10)
			var beam_color := Color(.92, .25, .08, .15)
			draw_colored_polygon(PackedVector2Array([origin, target + Vector2(-rect.size.x / 21, 0), target + Vector2(rect.size.x / 21, 0)]), beam_color)
			draw_line(origin, target, Color(1, .55, .19, .85), 2.0, true)
			draw_circle(target, 6, Color(1, .7, .3, .35))
			draw_circle(target, 2.5, Color(1, .9, .6))
		var emerge := minf(clampf(release / .22, 0, 1), clampf((1 - returning) / .22, 0, 1))
		_bee(scout, 46 * lerpf(.25, 1.0, emerge), elapsed * 45 + i, facing)

func _bee(center: Vector2, length_: float, flap: float, facing: float = 0.0) -> void:
	var s := length_ / 260.0
	draw_set_transform(center, facing, Vector2.ONE * s)
	# Overhead paired wings beat sideways; the sprite's head remains north.
	for side in [-1.0, 1.0]:
		for pair in 2:
			var hinge := Vector2(side * 25, -43 + pair * 17)
			var spread := 35.0 + absf(sin(flap + pair * .3)) * 62.0
			var points := PackedVector2Array()
			for step in 17:
				var angle := TAU * step / 16.0
				points.append(hinge + Vector2(side * (1 - cos(angle)) * spread * .5, sin(angle) * 17 + (1 - cos(angle)) * (8 + pair * 7)))
			draw_colored_polygon(points, Color(.8, .94, 1, .48))
			draw_polyline(points, Color(.96, .78, .42, .8), 1.3, true)
			draw_line(hinge, hinge + Vector2(side * spread, 16 + pair * 14), Color(.95, .82, .57, .5), 1.0, true)
	var size_ := Vector2(260.0 * BODY.get_width() / BODY.get_height(), 260)
	draw_texture_rect(BODY, Rect2(-size_ / 2, size_), false)
	draw_set_transform(Vector2.ZERO)

func _ease(value: float) -> float:
	return value * value * (3.0 - 2.0 * value)
