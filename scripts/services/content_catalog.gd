extends RefCounted
## The legacy mapping is authored data, never inferred from translated titles/order.
const IDS_PATH = "res://data/content_ids.json"
var ids: Dictionary = JSON.parse_string(FileAccess.get_file_as_string(IDS_PATH))

func legacy_art(index: int) -> String:
	return str(ids.legacy_art_ids.get(str(index), ""))

func has_art(art_id: String) -> bool:
	return ids.art_ids.has(art_id)

func art_index(levels: Array, art_id: String) -> int:
	for index in levels.size():
		if levels[index].get("art_id", "") == art_id: return index
	return -1

func frame_id(index: int) -> String:
	return "floor_%02d_frame_%02d" % [index / 5 + 1, index % 5 + 1]

func frame_index(id: String) -> int:
	for index in 50:
		if frame_id(index) == id: return index
	return -1

func fingerprint(level: Dictionary) -> String:
	# Text, display ordering and new translations do not invalidate a heist.
	var rules: Array = []
	for key in ["art_id", "level_id", "width", "height", "cells", "lanes", "palette", "queue_seconds"]:
		rules.append(level.get(key))
	rules.append(level.get("slot_count", level.lanes.size()))
	rules.append(level.get("entry_mode", "all"))
	return JSON.stringify(rules).sha256_text()

## A changed painting resumes against its archived board, never a different grid.
func matching_version(level: Dictionary, content_hash: String) -> Dictionary:
	if content_hash.is_empty(): return {}
	if content_hash == fingerprint(level) or content_hash == level.get("legacy_fingerprint", ""): return level
	for previous in level.get("previous_versions", []):
		if content_hash == fingerprint(previous) or content_hash == previous.get("legacy_fingerprint", ""): return previous
	return {}
