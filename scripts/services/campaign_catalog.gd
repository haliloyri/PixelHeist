extends RefCounted
## r13 linear campaign: 20 chapters x 5 heists, played in order (design sections 4-7).
## Chapters without authored puzzles stay locked behind "coming soon".
const PATH := "res://data/chapters.json"
var data: Dictionary = JSON.parse_string(FileAccess.get_file_as_string(PATH))
var chapters: Array = data.chapters
var crew: Array = data.crew
var endings: Dictionary = data.endings
var opening: Array = data.opening
var stages: Array = JSON.parse_string(FileAccess.get_file_as_string("res://data/stages.json"))
var artwork_placement: Array = JSON.parse_string(FileAccess.get_file_as_string("res://data/artwork_placement.json"))
var artwork_images: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/artwork_images.json"))
var pixel_visuals: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/pixel_visuals.json"))
var source_pixel_boards: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/source_pixel_boards.json"))
var source_pixel_history: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/source_pixel_history.json"))
const LEVEL_COUNT := 100
const LEVELS_PER_STAGE := 10

func stage_by_number(number: int) -> Dictionary:
	return stages[number-1] if number>=1 and number<=stages.size() else {}

func stage_for_level(number: int) -> Dictionary:
	return stage_by_number((clampi(number,1,LEVEL_COUNT)-1)/LEVELS_PER_STAGE+1)

func level_number(art_id: String) -> int:
	for slot in artwork_placement:
		if slot.art_id == art_id: return int(slot.level)
	return 0

## Ten fixed exhibition slots, including future content without inventing playable art.
func stage_slots(number: int) -> Array:
	var stage := stage_by_number(number)
	var slots: Array = []
	if stage.is_empty(): return slots
	for slot in artwork_placement:
		if int(slot.level)>=int(stage.first_level) and int(slot.level)<=int(stage.last_level):
			slots.append(slot.duplicate(true))
	return slots

func stage_progress(number: int, completed: Array) -> int:
	var count := 0
	for slot in stage_slots(number):
		if not slot.art_id.is_empty() and completed.has(slot.art_id): count+=1
	return count
var packet_queues: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/large_packet_queues.json"))

## Playable heist art IDs in campaign order.
func order() -> Array:
	var result: Array = []
	for chapter in chapters:
		result.append_array(chapter.heists)
	return result

## Level dictionaries (from levels.json) in campaign order.
func levels(all_levels: Array) -> Array:
	var by_id := {}
	for level in all_levels: by_id[level.art_id] = level
	var result: Array = []
	for art_id in order():
		if by_id.has(art_id):
			var level: Dictionary = by_id[art_id].duplicate(true)
			if pixel_visuals.has(art_id): level.pixel_visual_path = pixel_visuals[art_id].path
			if packet_queues.has(art_id):
				level.legacy_fingerprint = preload("res://scripts/services/content_catalog.gd").new().fingerprint(level)
				level.lanes = packet_queues[art_id].lanes.duplicate(true)
				level.solution = packet_queues[art_id].solution.duplicate()
				level.queue_version = 2
			if source_pixel_boards.has(art_id):
				var previous := level.duplicate(true)
				for key in source_pixel_boards[art_id]: level[key] = source_pixel_boards[art_id][key]
				level.erase("legacy_fingerprint")
				level.previous_versions = [previous]
				for archived in source_pixel_history.get(art_id, []):
					var historic := previous.duplicate(true)
					for key in archived: historic[key] = archived[key]
					historic.erase("legacy_fingerprint")
					level.previous_versions.append(historic)
			result.append(level)
	return result

func chapter_of(art_id: String) -> Dictionary:
	for chapter in chapters:
		if chapter.heists.has(art_id): return chapter
	return {}

func chapter_by_number(number: int) -> Dictionary:
	if number < 1 or number > chapters.size(): return {}
	return chapters[number - 1]

func position(art_id: String) -> int:
	var chapter := chapter_of(art_id)
	return chapter.heists.find(art_id) if not chapter.is_empty() else -1

func is_finale(art_id: String) -> bool:
	return position(art_id) == 4

func difficulty(art_id: String) -> String:
	var chapter := chapter_of(art_id)
	if chapter.is_empty(): return ""
	return str(chapter.difficulty[position(art_id)])

func win_bubble(art_id: String) -> Dictionary:
	var chapter := chapter_of(art_id)
	if chapter.is_empty(): return {}
	return chapter.win_bubbles[position(art_id)]

func crew_entry(id: String) -> Dictionary:
	for entry in crew:
		if entry.id == id: return entry
	return {}

## The chapter that unlocks a crew member (0 when none).
func crew_chapter(id: String) -> int:
	for chapter in chapters:
		if chapter.crew == id: return int(chapter.number)
	return 0

## The next chapter after a finished one has authored puzzles.
func has_content(number: int) -> bool:
	var chapter := chapter_by_number(number)
	return not chapter.is_empty() and chapter.heists.size() == 5
