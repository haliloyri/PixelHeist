@tool
extends RefCounted
## Stable gettext keys. Locale is presentation state, never a content identity.
const SUPPORTED = ["en", "tr", "es", "de"]
const NAMES = {"en": "English", "tr": "Türkçe", "es": "Español", "de": "Deutsch"}
static var source: Dictionary = {}
static var missing: Dictionary = {}
static var pseudo := false

static func _source() -> Dictionary:
	if source.is_empty(): source = JSON.parse_string(FileAccess.get_file_as_string("res://localization/source.json"))
	return source

static func resolve(preference: String, device: String = "") -> String:
	if SUPPORTED.has(preference): return preference
	var language := (OS.get_locale() if device.is_empty() else device).replace("-", "_").get_slice("_", 0).to_lower()
	return language if SUPPORTED.has(language) else "en"

static func select(preference: String, device: String = "") -> void:
	TranslationServer.set_locale(resolve(preference, device))

static func text(key: String, values: Dictionary = {}) -> String:
	var entry: Dictionary = _source().get(key, {})
	if entry.is_empty():
		missing[key] = true
		return key
	var translated := str(TranslationServer.translate(key, entry.context))
	if translated == key: translated = entry.text
	return _format(translated, values)

static func plural(key: String, count: int, values: Dictionary = {}) -> String:
	var entry: Dictionary = _source().get(key, {})
	if entry.is_empty() or not entry.has("plural"):
		missing[key] = true
		return key
	var translated := str(TranslationServer.translate_plural(key, key + ".plural", count, entry.context))
	if translated in [key, key + ".plural"]: translated = entry.text if count == 1 else entry.plural
	var args := values.duplicate()
	args.count = number(count)
	return _format(translated, args)

static func _format(pattern: String, values: Dictionary) -> String:
	if pseudo:
		# Expand only literal text; named placeholders are protected until formatting.
		var expanded := ""
		var inside := false
		for letter in pattern:
			if letter == "{": inside = true
			expanded += letter
			if not inside and letter.to_lower() in ["a", "e", "i", "o", "u"]: expanded += letter
			if letter == "}": inside = false
		pattern = "[" + expanded + "]"
	return pattern.format(values)

static func number(value: float, decimals: int = 0) -> String:
	var locale := TranslationServer.get_locale().get_slice("_", 0)
	var parts := ("%.*f" % [clampi(decimals, 0, 6), value]).split(".")
	var whole: String = parts[0]
	var sign_text := "-" if whole.begins_with("-") else ""
	whole = whole.trim_prefix("-")
	var grouped := ""
	var separator := "," if locale == "en" else "."
	for i in whole.length():
		if i > 0 and (whole.length() - i) % 3 == 0 and not (locale == "es" and whole.length() == 4): grouped += separator
		grouped += whole[i]
	return sign_text + grouped + (("." if locale == "en" else ",") + parts[1] if parts.size() > 1 else "")

static func upper(value: String) -> String:
	if TranslationServer.get_locale().begins_with("tr"): value = value.replace("i", "İ").replace("ı", "I")
	return value.to_upper()

static func fit(control: Control, preferred: int, minimum: int = 16) -> void:
	if not (control is Label or control is Button) or control.size.x <= 0: return
	minimum = mini(minimum, preferred)
	var font: Font = control.get_theme_font("font")
	var bounds: Vector2 = control.get_meta("text_bounds", control.size)
	control.set_meta("text_bounds", bounds)
	var width: float = bounds.x - (28 if control is Button else 0)
	var height: float = bounds.y - (8 if control is Button else 0)
	for font_size in range(preferred, minimum - 1, -1):
		control.add_theme_font_size_override("font_size", font_size)
		var extent: Vector2 = font.get_multiline_string_size(control.text, HORIZONTAL_ALIGNMENT_LEFT, width, font_size, -1, TextServer.BREAK_MANDATORY | TextServer.BREAK_WORD_BOUND | TextServer.BREAK_ADAPTIVE) if control is Label else font.get_string_size(control.text, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size)
		if extent.x <= width + 1 and extent.y <= height + 1: break
	control.size = bounds

static func localize_tree(node: Node) -> void:
	if node is Control:
		if node is Label or node is Button:
			if not node.has_meta("text_bounds"): node.set_meta("text_bounds", node.size)
			if _source().has(node.text): node.text = text(node.text)
			fit(node, node.get_theme_font_size("font_size"), 14)
		if _source().has(node.tooltip_text): node.tooltip_text = text(node.tooltip_text)
	for child in node.get_children(): localize_tree(child)
