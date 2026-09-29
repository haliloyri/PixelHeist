extends RefCounted
## r13 save (schema 2): one checksummed primary + mirror written atomically through
## AtomicStore. Older r12 (v1) and pre-P02 ConfigFile saves migrate once, read-only:
## every artwork ever acquired joins the Gallery and credits convert 1:1 to gold.
## Economy rules (design section 12) live here so every grant is a single commit.
const AtomicStore = preload("res://scripts/services/atomic_store.gd")
const LegacyStore = preload("res://scripts/services/legacy_save_store.gd")
const Catalog = preload("res://scripts/services/content_catalog.gd")
const CampaignCatalog = preload("res://scripts/services/campaign_catalog.gd")
const VERSION := 2
const SUFFIX := ".v2"
var rules: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/economy_r13.json"))
var storage = AtomicStore.new()
var catalog = Catalog.new()
var campaign = CampaignCatalog.new()
var state: Dictionary = {}
var base_path := ""
var read_only := false
var status := "new"
var last_error := ""
## Tests inject a clock; production uses the system clock (seconds).
var clock: Callable = func() -> int: return int(Time.get_unix_time_from_system())

func now() -> int:
	return int(clock.call())

func today() -> String:
	return Time.get_date_string_from_unix_time(now())

func fresh() -> Dictionary:
	var boosters := {}
	for id in rules.boosters: boosters[id] = 0
	return {
		"schema_version": VERSION, "generation": 0,
		"save_id": Crypto.new().generate_random_bytes(16).hex_encode(),
		"completed": [], "stars": {}, "gold": int(rules.start_gold),
		"energy": int(rules.energy_max), "energy_at": now(), "unlimited_until": 0,
		"speed3_until": 0,
		"boosters": boosters,
		"chests": {"daily_last": "", "daily_streak": 0, "star_opened": 0, "chapter_claimed": []},
		"crew": {"equipped": ""}, "looks": {"owned": ["drone_copper", "box_wood"], "equipped": {"drone": "drone_copper", "box": "box_wood"}},
		"entitlements": {}, "purchases": {},
		"ads": {"day": "", "free_coins": 0, "since_interstitial": 0, "last_interstitial": 0},
		"story": {"opening": false, "seen": [], "ending": ""},
		"tutorial": {"gift": false},
		"collection": empty_collection(),
		"settings": {"sound": true, "music": true, "vibration": true, "reduced_motion": false},
		"session": {}, "grants": {},
		"migration": {"source": "none"},
	}

static func _int(value, maximum: int = 1000000000) -> bool:
	return (value is int or value is float) and is_finite(float(value)) and float(value) == floor(float(value)) and value >= 0 and value <= maximum

func validate(s: Dictionary) -> String:
	if s.get("schema_version") != VERSION: return "unsupported_schema"
	if not _int(s.get("generation")): return "generation"
	if not s.get("save_id") is String or s.save_id.length() != 32: return "save_id"
	for key in ["stars", "boosters", "chests", "crew", "looks", "entitlements", "purchases", "ads", "story", "tutorial", "settings", "session", "grants", "migration"]:
		if not s.get(key) is Dictionary: return key
	if not s.get("completed") is Array: return "completed"
	var seen := {}
	for art_id in s.completed:
		if not art_id is String or seen.has(art_id): return "completed_id"
		seen[art_id] = true
	for art_id in s.stars:
		if not seen.has(art_id) or not _int(s.stars[art_id], 3) or int(s.stars[art_id]) < 1: return "stars"
	for key in ["gold", "energy_at", "unlimited_until"]:
		if not _int(s.get(key), 100000000000): return key
	if s.has("speed3_until") and not _int(s.speed3_until,100000000000): return "speed3_until"
	if not _int(s.get("energy"), int(rules.energy_max)): return "energy"
	for id in rules.boosters:
		if id == "row_beam" and not s.boosters.has(id): continue
		if not _int(s.boosters.get(id), 9999): return "booster"
	for id in s.boosters:
		if not rules.boosters.has(id): return "booster_ids"
	if not s.chests.get("daily_last") is String or not _int(s.chests.get("daily_streak"), 6): return "daily"
	if not _int(s.chests.get("star_opened")) or not s.chests.get("chapter_claimed") is Array: return "chests"
	for key in ["sound", "music", "vibration", "reduced_motion"]:
		if not s.settings.get(key) is bool: return "settings"
	if not s.looks.get("owned") is Array or not s.looks.get("equipped") is Dictionary: return "looks"
	for look in s.looks.owned:
		if not rules.looks.has(look): return "look_id"
	for product in s.entitlements:
		if not rules.products.has(product) or not s.entitlements[product] is bool: return "entitlement"
	if s.has("collection"):
		var collection_error := validate_collection(s.collection,s.completed)
		if not collection_error.is_empty(): return collection_error
	return ""

# --- files -------------------------------------------------------------------

func open(path: String) -> Dictionary:
	base_path = path
	read_only = false
	last_error = ""
	state = fresh()
	var existed := false
	var candidates: Array = []
	for suffix in [SUFFIX, SUFFIX + ".bak"]:
		var result: Dictionary = storage.read_file(path + suffix)
		existed = existed or result.status != "missing"
		if result.status != "ok": continue
		if result.data.get("schema_version") != VERSION: return _lock("unsupported_schema")
		if validate(result.data).is_empty(): candidates.append({"data": result.data, "source": suffix})
	if not candidates.is_empty():
		candidates.sort_custom(func(a, b): return a.data.generation > b.data.generation)
		state = candidates[0].data
		if not state.boosters.has("row_beam"): state.boosters.row_beam = 0
		if not state.has("speed3_until"): state.speed3_until = 0
		if not state.has("collection"): state.collection = empty_collection()
		status = "loaded" if candidates[0].source == SUFFIX else "recovered_backup"
		regenerate()
		return {"status": status}
	if existed: return _lock("save_unreadable")
	var migrated := _migrate(path)
	if migrated.has("locked"): return _lock(str(migrated.locked))
	status = str(migrated.get("status", "new"))
	if commit(state.duplicate(true)) != OK: return _lock("initial_save_failed")
	return {"status": status}

func _lock(reason: String) -> Dictionary:
	read_only = true
	last_error = reason
	status = reason
	return {"status": reason}

## r12 (v1) and pre-P02 ConfigFile saves are read, never written.
func _migrate(path: String) -> Dictionary:
	var v1: Dictionary = {}
	for suffix in [".v1", ".v1.bak"]:
		var result: Dictionary = storage.read_file(path + suffix)
		if result.status == "ok" and result.data is Dictionary and result.data.get("schema_version") == 1:
			if v1.is_empty() or int(result.data.get("generation", 0)) > int(v1.get("generation", 0)): v1 = result.data
	var order: Array = campaign.order()
	if not v1.is_empty():
		var acquired: Dictionary = v1.get("acquired", {}) if v1.get("acquired") is Dictionary else {}
		for art_id in order:
			if acquired.has(art_id): _complete(state, art_id, 3)
		var wallet = v1.get("wallet", {})
		if wallet is Dictionary and _int(wallet.get("credits")): state.gold += int(wallet.credits)
		var settings = v1.get("settings", {})
		if settings is Dictionary:
			for pair in [["sound", "sound"], ["tension_music", "music"], ["reduced_motion", "reduced_motion"]]:
				if settings.get(pair[0]) is bool: state.settings[pair[1]] = settings[pair[0]]
		state.migration = {"source": "r12_v1", "ignored": ["paths", "news", "labels", "trust", "boost", "notes"],
			"dropped_art": acquired.keys().filter(func(a): return not order.has(a))}
		if not state.completed.is_empty(): state.story.opening = true
		return {"status": "migrated"}
	if FileAccess.file_exists(path):
		var legacy: Dictionary = LegacyStore.new().load_progress(path, catalog.ids.legacy_art_ids.size(), 15, 600)
		if legacy.is_empty(): return {"locked": "legacy_unreadable"}
		for index in legacy.completed:
			var art_id: String = catalog.legacy_art(int(index))
			if order.has(art_id): _complete(state, art_id, 3)
		state.settings.sound = legacy.sound
		state.settings.music = legacy.tension_music
		state.settings.reduced_motion = legacy.reduced_motion
		state.migration = {"source": "legacy_config"}
		if not state.completed.is_empty(): state.story.opening = true
		return {"status": "migrated"}
	return {"status": "new"}

func commit(candidate: Dictionary) -> Error:
	if read_only: return ERR_FILE_CANT_WRITE
	var error := validate(candidate)
	if not error.is_empty():
		last_error = error
		return ERR_INVALID_DATA
	for suffix in [SUFFIX, SUFFIX + ".bak"]:
		var disk: Dictionary = storage.read_file(base_path + suffix)
		if disk.status == "ok" and int(disk.data.get("generation", -1)) > int(state.get("generation", 0)) and disk.data.get("save_id") == state.save_id:
			last_error = "stale_writer"
			return ERR_BUSY
	candidate.generation = int(state.get("generation", 0)) + 1
	var result: Error = storage.write(base_path + SUFFIX, candidate)
	if result == OK:
		state = candidate.duplicate(true)
		last_error = "" if storage.backup_error == OK else "backup_write_failed"
	else:
		last_error = "save_write_failed"
	return result

## Runs one mutation on a copy and commits it; nothing changes on failure.
func apply(mutation: Callable) -> bool:
	if read_only: return false
	var candidate := state.duplicate(true)
	var ok = mutation.call(candidate)
	if ok == false: return false
	return commit(candidate) == OK

static func empty_collection() -> Dictionary:
	return {"title":"My Midnight Collection","art_ids":[],"featured":"","theme":"midnight","layout":"spotlight"}

func validate_collection(value, owned: Array) -> String:
	if not value is Dictionary: return "collection"
	if not value.get("title") is String or value.title.strip_edges().is_empty() or value.title.length()>32: return "collection_title"
	for character in value.title:
		if character.unicode_at(0)<32: return "collection_title"
	if not value.get("art_ids") is Array or value.art_ids.size()>10: return "collection_size"
	var seen := {}
	for id in value.art_ids:
		if not id is String or seen.has(id) or not owned.has(id) or not campaign.order().has(id): return "collection_art"
		seen[id]=true
	if not value.get("featured") is String or (value.featured!="" and not seen.has(value.featured)): return "collection_featured"
	if not ["midnight","emerald","burgundy"].has(value.get("theme")): return "collection_theme"
	if not ["spotlight","pairs","salon"].has(value.get("layout","spotlight")): return "collection_layout"
	return ""

func collection() -> Dictionary:
	var value:Dictionary=state.get("collection",empty_collection()).duplicate(true)
	# Preserve the visible hero/order from legacy rooms without mutating a save on read.
	if not value.has("layout"):
		value.layout="spotlight"
		if value.art_ids.has(value.featured):
			value.art_ids.erase(value.featured)
			value.art_ids.push_front(value.featured)
	return value

func save_collection(value: Dictionary) -> bool:
	if not validate_collection(value,state.completed).is_empty(): return false
	return apply(func(s): s.collection=value.duplicate(true);return true)

func toggle_collection(art_id: String) -> bool:
	var value := collection()
	if value.art_ids.has(art_id):
		value.art_ids.erase(art_id)
		if value.featured==art_id: value.featured=""
	else:
		if value.art_ids.size()>=10: return false
		value.art_ids.append(art_id)
	return save_collection(value)

func move_collection(art_id: String, offset: int) -> bool:
	var value := collection()
	var index: int = value.art_ids.find(art_id)
	if index<0 or index+offset<0 or index+offset>=value.art_ids.size(): return false
	value.art_ids.remove_at(index)
	value.art_ids.insert(index+offset,art_id)
	return save_collection(value)

# --- campaign ----------------------------------------------------------------

func next_art(order: Array) -> String:
	for art_id in order:
		if not state.completed.has(art_id): return art_id
	return ""

func _complete(s: Dictionary, art_id: String, stars: int) -> bool:
	var first: bool = not s.completed.has(art_id)
	if first: s.completed.append(art_id)
	s.stars[art_id] = maxi(int(s.stars.get(art_id, 0)), clampi(stars, 1, 3))
	return first

static func stars_for(boosters_used: int, continues: int) -> int:
	var uses := boosters_used + continues
	return 3 if uses == 0 else (2 if uses == 1 else 1)

## Records a win: first completion pays by difficulty, replays pay a little.
func record_win(art_id: String, difficulty: String, stars: int) -> Dictionary:
	var result := {}
	var ok := apply(func(s):
		var before: int = int(s.stars.get(art_id, 0))
		var first := _complete(s, art_id, stars)
		var gold: int = int(rules.win_gold.get(difficulty, rules.win_gold[""])) if first else int(rules.replay_gold)
		s.gold += gold
		s.session = {}
		if s.completed.size() >= int(rules.tutorial_gift_heist) and not s.tutorial.gift:
			s.tutorial.gift = true
			for id in rules.tutorial_gift: s.boosters[id] += int(rules.tutorial_gift[id])
		result.merge({"first": first, "gold": gold, "stars": int(s.stars[art_id]), "new_stars": maxi(0, int(s.stars[art_id]) - before)})
		return true)
	if not ok: return {}
	return result

func star_total() -> int:
	var total := 0
	for value in state.stars.values(): total += int(value)
	return total

# --- energy ------------------------------------------------------------------

func unlimited_energy() -> bool:
	return int(state.unlimited_until) > now()

## Applies time-based refill in memory (committed with the next write).
func regenerate() -> void:
	var maximum: int = int(rules.energy_max)
	var period: int = int(rules.energy_refill_seconds)
	if int(state.energy) >= maximum:
		state.energy_at = now()
		return
	var gained: int = maxi(0, (now() - int(state.energy_at)) / period)
	if gained <= 0: return
	state.energy = mini(maximum, int(state.energy) + gained)
	state.energy_at = now() if int(state.energy) >= maximum else int(state.energy_at) + gained * period

func seconds_to_next_energy() -> int:
	regenerate()
	if int(state.energy) >= int(rules.energy_max): return 0
	return maxi(0, int(state.energy_at) + int(rules.energy_refill_seconds) - now())

func has_energy() -> bool:
	regenerate()
	return unlimited_energy() or int(state.energy) > 0

## Failure, Retry and Home from a heist cost one energy.
func spend_energy(session_after: Dictionary = {}) -> bool:
	regenerate()
	return apply(func(s):
		s.session = session_after.duplicate(true)
		if int(s.unlimited_until) > now(): return true
		if int(s.energy) >= int(rules.energy_max): s.energy_at = now()
		s.energy = maxi(0, int(s.energy) - 1)
		return true)

func refill_energy_gold() -> bool:
	regenerate()
	if int(state.gold) < int(rules.energy_refill_gold) or int(state.energy) >= int(rules.energy_max): return false
	return apply(func(s):
		s.gold -= int(rules.energy_refill_gold)
		s.energy = int(rules.energy_max)
		s.energy_at = now()
		return true)

func grant_energy(amount: int) -> bool:
	regenerate()
	return apply(func(s):
		s.energy = mini(int(rules.energy_max), int(s.energy) + amount)
		if int(s.energy) >= int(rules.energy_max): s.energy_at = now()
		return true)

# --- boosters and gold -----------------------------------------------------

func booster_count(id: String) -> int:
	return int(state.boosters.get(id, 0))

func use_booster(id: String, session_after: Dictionary) -> bool:
	if booster_count(id) <= 0: return false
	return apply(func(s):
		s.boosters[id] -= 1
		s.session = session_after.duplicate(true)
		return true)

func buy_booster(id: String, count: int = 1) -> bool:
	var price: int = int(rules.booster_price) * count
	if not rules.boosters.has(id) or int(state.gold) < price: return false
	return apply(func(s):
		s.gold -= price
		s.boosters[id] += count
		return true)

func spend_gold(amount: int, session_after: Dictionary = {}) -> bool:
	if int(state.gold) < amount: return false
	return apply(func(s):
		s.gold -= amount
		s.session = session_after.duplicate(true)
		return true)

func speed3_remaining() -> int:
	return maxi(0,int(state.get("speed3_until",0))-now())

## One atomic game-gold purchase grants five wall-clock minutes across heists.
func unlock_speed3(session_after: Dictionary) -> bool:
	var price: int = int(rules.speed3_gold)
	if read_only or speed3_remaining()>0 or int(state.gold)<price: return false
	return apply(func(s):
		s.gold -= price
		s.speed3_until = now()+int(rules.speed3_seconds)
		s.session = session_after.duplicate(true)
		return true)

func _grant_boosters(s: Dictionary, count: int, seed: int) -> Array:
	var ids: Array = rules.boosters
	var given: Array = []
	for i in count:
		var id: String = ids[(seed + i) % ids.size()]
		s.boosters[id] += 1
		given.append(id)
	return given

# --- chests -----------------------------------------------------------------

func daily_ready() -> bool:
	return str(state.chests.daily_last) != today()

func daily_day() -> int:
	var last: String = state.chests.daily_last
	if last == "": return 0
	var yesterday := Time.get_date_string_from_unix_time(now() - 86400)
	return (int(state.chests.daily_streak) + 1) % 7 if last == yesterday else 0

func claim_daily() -> Dictionary:
	if not daily_ready(): return {}
	var day := daily_day()
	var reward: Dictionary = rules.daily[day]
	var result := {}
	var ok := apply(func(s):
		s.chests.daily_last = today()
		s.chests.daily_streak = day
		s.gold += int(reward.gold)
		result.merge({"kind": "daily", "day": day, "gold": int(reward.gold), "boosters": _grant_boosters(s, int(reward.boosters), day)})
		return true)
	return result if ok else {}

func star_chests_ready() -> int:
	return star_total() / int(rules.stars_per_chest) - int(state.chests.star_opened)

func star_progress() -> int:
	return star_total() % int(rules.stars_per_chest) if star_chests_ready() <= 0 else int(rules.stars_per_chest)

func claim_star_chest() -> Dictionary:
	if star_chests_ready() <= 0: return {}
	var result := {}
	var ok := apply(func(s):
		var opened: int = int(s.chests.star_opened)
		s.chests.star_opened = opened + 1
		s.gold += int(rules.star_chest.gold)
		result.merge({"kind": "star", "gold": int(rules.star_chest.gold), "boosters": _grant_boosters(s, int(rules.star_chest.boosters), opened)})
		return true)
	return result if ok else {}

func chapter_complete(chapter: Dictionary) -> bool:
	if chapter.heists.size() != 5: return false
	for art_id in chapter.heists:
		if not state.completed.has(art_id): return false
	return true

func chapter_chest_ready(chapter: Dictionary) -> bool:
	return chapter_complete(chapter) and not state.chests.chapter_claimed.has(chapter.id)

func claim_chapter_chest(chapter: Dictionary) -> Dictionary:
	if not chapter_chest_ready(chapter): return {}
	var result := {}
	var ok := apply(func(s):
		s.chests.chapter_claimed.append(chapter.id)
		s.gold += int(rules.chapter_chest.gold)
		result.merge({"kind": "stage" if int(chapter.number)%2==0 else "chapter", "chapter": chapter.id, "gold": int(rules.chapter_chest.gold), "boosters": _grant_boosters(s, int(rules.chapter_chest.boosters), int(chapter.number))})
		return true)
	return result if ok else {}

# --- crew, looks, story, settings --------------------------------------------

func unlocked_crew() -> Array:
	var result: Array = []
	for chapter in campaign.chapters:
		if chapter.crew != "" and chapter_complete(chapter): result.append(chapter.crew)
	return result

func equip_crew(id: String) -> bool:
	if not unlocked_crew().has(id): return false
	return apply(func(s): s.crew.equipped = id; return true)

func buy_look(id: String) -> bool:
	var look: Dictionary = rules.looks.get(id, {})
	if look.is_empty() or int(look.price) < 0 or state.looks.owned.has(id) or int(state.gold) < int(look.price): return false
	return apply(func(s):
		s.gold -= int(look.price)
		s.looks.owned.append(id)
		s.looks.equipped[look.slot] = id
		return true)

func equip_look(id: String) -> bool:
	if not state.looks.owned.has(id): return false
	return apply(func(s): s.looks.equipped[rules.looks[id].slot] = id; return true)

func mark_story(chapter_id: String) -> bool:
	return apply(func(s):
		if chapter_id == "opening": s.story.opening = true
		elif not s.story.seen.has(chapter_id): s.story.seen.append(chapter_id)
		return true)

func choose_ending(ending_id: String) -> bool:
	if not campaign.endings.has(ending_id): return false
	return apply(func(s): s.story.ending = ending_id; return true)

func set_setting(key: String, value: bool) -> bool:
	return apply(func(s): s.settings[key] = value; return true)

func save_session(session: Dictionary) -> bool:
	return apply(func(s): s.session = session.duplicate(true); return true)

# --- purchases and ads (providers deliver verified events) -------------------

func owns(product_id: String) -> bool:
	return bool(state.entitlements.get(product_id, false))

func no_ads() -> bool:
	return owns("no_ads") or owns("no_ads_pack")

func product_available(product_id: String) -> bool:
	var product: Dictionary = rules.products.get(product_id, {})
	return not product.is_empty() and not (product.get("once", false) and owns(product_id))

## Grants a verified purchase exactly once per platform transaction id.
func grant_purchase(product_id: String, transaction_id: String) -> bool:
	var product: Dictionary = rules.products.get(product_id, {})
	if product.is_empty() or transaction_id.is_empty(): return false
	if state.purchases.has(transaction_id): return true
	if product.get("once", false) and owns(product_id): return false
	return apply(func(s):
		s.purchases[transaction_id] = product_id
		s.gold += int(product.get("gold", 0))
		if product.has("boosters"):
			for id in rules.boosters: s.boosters[id] += int(product.boosters)
		if product.has("unlimited_energy_seconds"):
			s.unlimited_until = maxi(int(s.unlimited_until), now()) + int(product.unlimited_energy_seconds)
		if product.has("look") and not s.looks.owned.has(product.look): s.looks.owned.append(product.look)
		if product.get("once", false): s.entitlements[product_id] = true
		return true)

## Restore re-grants permanent entitlements only (no gold or boosters again).
func restore_entitlement(product_id: String) -> bool:
	var product: Dictionary = rules.products.get(product_id, {})
	if product.is_empty() or not product.get("once", false) or owns(product_id): return false
	return apply(func(s):
		s.entitlements[product_id] = true
		if product.has("look") and not s.looks.owned.has(product.look): s.looks.owned.append(product.look)
		return true)

func _ads_day(s: Dictionary) -> void:
	if str(s.ads.day) != today():
		s.ads.day = today()
		s.ads.free_coins = 0

func free_coins_left() -> int:
	var count: int = int(state.ads.free_coins) if str(state.ads.day) == today() else 0
	return maxi(0, int(rules.free_coins_daily_cap) - count)

## Grants a rewarded-ad reward from a verified provider event.
func grant_ad_reward(kind: String, event_id: String, session_after = null) -> Dictionary:
	if event_id.is_empty() or state.grants.has(event_id): return {}
	var result := {}
	var ok := apply(func(s):
		_ads_day(s)
		match kind:
			"free_coins":
				if int(s.ads.free_coins) >= int(rules.free_coins_daily_cap): return false
				s.ads.free_coins += 1
				s.gold += int(rules.free_coins_gold)
				result.merge({"kind": "ad", "gold": int(rules.free_coins_gold), "boosters": []})
			"energy":
				s.energy = mini(int(rules.energy_max), int(s.energy) + 1)
				result.merge({"kind": "energy"})
			"continue":
				result.merge({"kind": "continue"})
			_:
				if kind.begins_with("double:"):
					var gold: int = int(kind.trim_prefix("double:"))
					s.gold += gold
					result.merge({"kind": "double", "gold": gold})
				else: return false
		s.grants[event_id] = kind
		if session_after is Dictionary: s.session = session_after.duplicate(true)
		return true)
	return result if ok else {}

## Interstitial rules: only after a win, from heist 8, every 2 heists and 3 minutes.
func note_win_for_ads() -> bool:
	if no_ads() or state.completed.size() < int(rules.ads_from_heist): return false
	var due: bool = int(state.ads.since_interstitial) + 1 >= int(rules.interstitial_every_heists) and now() - int(state.ads.last_interstitial) >= int(rules.interstitial_min_seconds)
	apply(func(s):
		if due:
			s.ads.since_interstitial = 0
			s.ads.last_interstitial = now()
		else: s.ads.since_interstitial += 1
		return true)
	return due
