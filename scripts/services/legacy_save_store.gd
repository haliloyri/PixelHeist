extends RefCounted
## Read-only migration source in production; the writer remains for legacy fixtures.

func load_progress(path: String, art_count: int, slot_count: int, boost_seconds: float) -> Dictionary:
	var config := ConfigFile.new()
	if config.load(path) != OK:
		return {}
	var completed: Array = []
	var saved = config.get_value("progress", "completed", [])
	var saved_slots = config.get_value("progress", "gallery_slots", [])
	var budget = config.get_value("boost", "remaining", boost_seconds)
	if not saved is Array or not saved_slots is Array: return {}
	if not (budget is int or budget is float) or not is_finite(float(budget)): return {}
	for key in ["reduced_motion", "sound", "tension_music"]:
		if not config.get_value("settings", key, false) is bool: return {}
	if saved is Array:
		for value in saved:
			if (value is int or value is float) and is_finite(float(value)) and value == floor(float(value)) and value >= 0 and value < art_count and not completed.has(int(value)):
				completed.append(int(value))
	completed.sort()
	var slots: Array = []
	slots.resize(slot_count)
	slots.fill(-1)
	if saved_slots is Array:
		for slot in mini(saved_slots.size(), slots.size()):
			var value = saved_slots[slot]
			if (value is int or value is float) and is_finite(float(value)) and value == floor(float(value)) and value >= 0 and value < art_count and completed.has(int(value)) and not slots.has(int(value)):
				slots[slot] = int(value)
	return {
		"completed": completed,
		"gallery_slots": slots,
		"reduced_motion": bool(config.get_value("settings", "reduced_motion", false)),
		"sound": bool(config.get_value("settings", "sound", true)),
		"tension_music": bool(config.get_value("settings", "tension_music", true)),
		"boost_remaining": clampf(float(config.get_value("boost", "remaining", boost_seconds)), 0, boost_seconds),
	}

func save_progress(path: String, progress: Dictionary) -> Error:
	var config := ConfigFile.new()
	config.set_value("progress", "completed", progress.completed)
	config.set_value("progress", "gallery_slots", progress.gallery_slots)
	config.set_value("settings", "reduced_motion", progress.reduced_motion)
	config.set_value("settings", "sound", progress.sound)
	config.set_value("settings", "tension_music", progress.tension_music)
	config.set_value("boost", "remaining", progress.boost_remaining)
	return config.save(path)
