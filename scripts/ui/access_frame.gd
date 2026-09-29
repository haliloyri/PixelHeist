@tool
extends Control
## Ant passages through the painting's bottom rail (2026-09-26, Halil).
## Every board is filled from below: the side and top rails of the gold frame stay
## sealed, and the ants cut two passages through the bottom rail, each as wide as
## four painting pixels (main.GAP_TILES), halfway between each corner rosette and the
## title plaque. The first ant pecks the rail three times (`peck`, seconds of pecking),
## then the passage breaks open (`open`, 0..1) and stays open for the heist.
const BAND := 20.0 ## Same moulding width as gallery_frame.gd.
const PECK_TIME := 1.0 ## main.PECK_TIME
const PECKS := 3
var cut_width := 16.0
var game: Control
var rect := Rect2(82,84,556,508):
	set(value):
		rect=value
		queue_redraw()
var gaps: Array = []:
	set(value):
		gaps=value
		queue_redraw()
var open: Array = [0.0, 0.0]
var peck: Array = [-1.0, -1.0]

func _ready()->void:
	mouse_filter=Control.MOUSE_FILTER_IGNORE

func _draw()->void:
	for i in gaps.size():
		var amount: float = clampf(float(open[i]) if i < open.size() else 0.0, 0.0, 1.0)
		var pecked: float = float(peck[i]) if i < peck.size() else -1.0
		if amount <= 0.0:
			if pecked >= 0.0: _pecking(float(gaps[i]), pecked, i)
			continue
		if amount < 1.0 and pecked >= 0.0: _pecking(float(gaps[i]), pecked, i)
		_cut(float(gaps[i]), amount, i)

## Each peck leaves a deeper dent and knocks a few gold flecks off the rail.
func _pecking(x: float, time: float, index: int) -> void:
	var bottom := rect.end.y
	var progress := clampf(time / PECK_TIME, 0.0, 1.0)
	var phase := progress * PECKS
	# Impacts land mid-peck (phase k + .5), matching the jab in flight_layer.gd.
	var done := floorf(phase + .5)
	var dent := cut_width * (.25 + .2 * done)
	var depth := 3.0 + 3.5 * done
	draw_colored_polygon(PackedVector2Array([Vector2(x - dent * .5, bottom), Vector2(x - dent * .2, bottom - depth), Vector2(x + dent * .25, bottom - depth * .8), Vector2(x + dent * .5, bottom)]), Color("141a2b"))
	for k in int(done) + 1:
		var crack_x := x + (float(k) - 1.0) * dent * .3
		draw_line(Vector2(crack_x, bottom - depth), Vector2(crack_x + (1.5 if k % 2 else -1.5), bottom - depth - 3.0 - k * 1.5), Color("5e3a0c"), 1.0)
	# Flecks burst at each impact (the peak of every peck).
	var local := phase - floorf(phase)
	if done > 0.0 and local >= .5:
		var t := (local - .5) / .5
		for k in 6:
			var angle := PI * .5 + (float(k) / 5.0 - .5) * 2.2 + float(index + int(done)) * .4
			var reach := (4.0 + float(k % 3) * 3.0) * t
			var fleck := Color("ffe08a") if k % 2 == 0 else Color("d9a032")
			fleck.a = 1.0 - t
			var at := Vector2(x, bottom) + Vector2.RIGHT.rotated(angle) * reach + Vector2(0, 5.0 * t * t)
			draw_rect(Rect2(at - Vector2.ONE, Vector2(2, 2)), fleck)

func _cut(x: float, amount: float, index: int) -> void:
	var top := rect.end.y - BAND
	var bottom := rect.end.y
	var width := cut_width * smoothstep(0.0, 1.0, amount)
	# The passage: the dark mat shows through the moulding, with a soft inner shadow.
	var slot := Rect2(x - width * .5, top - 1, width, bottom - top + 2)
	draw_rect(slot.grow_individual(1.2, 0, 1.2, 0), Color(0, 0, 0, .35 * amount))
	draw_rect(slot, Color("141a2b"))
	# Freshly cut gold edges: bright bevel with small jagged chips biting into the rail.
	var edge := Color("fff0b8")
	edge.a = amount
	var dark := Color("5e3a0c")
	dark.a = amount
	for side in [-1.0, 1.0]:
		var ex: float = x + side * width * .5
		draw_line(Vector2(ex, top), Vector2(ex, bottom), edge, 1.2)
		draw_line(Vector2(ex + side * 1.4, top), Vector2(ex + side * 1.4, bottom), dark, 1.0)
		var y := top + 2.0
		var n := 0
		while y < bottom - 2.0:
			var bite := 1.6 + float((n * 7 + index * 3) % 3) * .6
			draw_colored_polygon(PackedVector2Array([Vector2(ex, y), Vector2(ex + side * bite, y + 1.6), Vector2(ex, y + 3.2)]), Color("141a2b", amount))
			y += 4.2
			n += 1
	# While the cut is being made: a burst of gold filings and sparks.
	if amount < 1.0:
		var t := amount
		for k in 10:
			var angle := -PI * .5 + (float(k) / 9.0 - .5) * 2.6 + float(index) * .3
			var reach := (6.0 + float(k % 3) * 4.0) * t
			var from := Vector2(x, lerpf(top, bottom, float(k % 4) / 3.0))
			var spark := Color("ffe08a") if k % 2 == 0 else Color("fffaf0")
			spark.a = 1.0 - t
			draw_line(from + Vector2.RIGHT.rotated(angle) * reach * .4, from + Vector2.RIGHT.rotated(angle) * reach, spark, 1.4, true)
		draw_circle(Vector2(x, (top + bottom) * .5), 7.0 * (1.0 - t), Color(1, .93, .7, .45 * (1.0 - t)))
