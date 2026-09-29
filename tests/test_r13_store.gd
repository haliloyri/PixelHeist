extends SceneTree
## r13 save, migration and economy rules (design sections 12-14, 17). Isolated saves only.
const Store = preload("res://scripts/services/progress_store.gd")
const AtomicStore = preload("res://scripts/services/atomic_store.gd")
const LegacyStore = preload("res://scripts/services/legacy_save_store.gd")
var checks := 0
var failures := 0
var root_dir := ""
var fake_now := 1790000000

func check(ok: bool, label: String) -> void:
	checks += 1
	if not ok:
		failures += 1
		printerr("FAIL: ", label)

func _initialize() -> void: call_deferred("run")

func path(name: String) -> String:
	var dir := root_dir.path_join(name)
	DirAccess.make_dir_recursive_absolute(dir)
	return dir.path_join("progress.cfg")

func store_at(p: String):
	var s = Store.new()
	s.clock = func() -> int: return fake_now
	s.open(p)
	return s

func run() -> void:
	var temp := OS.get_environment("TMPDIR")
	if temp.is_empty(): temp = "/tmp"
	root_dir = temp.path_join("pixel-heist-r13-store-%d-%d" % [OS.get_process_id(), Time.get_ticks_usec()])
	DirAccess.make_dir_recursive_absolute(root_dir)

	# Fresh save.
	var s = store_at(path("fresh"))
	check(s.status == "new" and not s.read_only, "New save opens writable")
	check(int(s.state.gold) == 200 and int(s.state.energy) == 10, "Start: 200 gold, 10 energy")
	check(s.state.boosters.keys().size() == 5 and s.booster_count("zap") == 0, "Five compatible booster stocks, none owned")
	check(s.validate(s.state).is_empty(), "Fresh state validates")
	var generation: int = int(s.state.generation)
	check(s.set_setting("music", false), "Setting commits")
	var reopened = store_at(path("fresh"))
	check(not reopened.state.settings.music and int(reopened.state.generation) == generation + 1, "Reopen reads the newest generation")

	# Corrupt primary falls back to the mirror.
	var f := FileAccess.open(path("fresh") + ".v2", FileAccess.WRITE)
	f.store_string("garbage")
	f.close()
	var recovered = store_at(path("fresh"))
	check(recovered.status == "recovered_backup" and not recovered.state.settings.music, "Corrupt primary recovers from mirror")

	# Wins, stars, replay reward, tutorial gift.
	s = store_at(path("wins"))
	check(Store.stars_for(0, 0) == 3 and Store.stars_for(1, 0) == 2 and Store.stars_for(1, 1) == 1, "Stars: 3 / 2 / 1 by uses")
	var win: Dictionary = s.record_win("sun_seal", "", 3)
	check(win.first and int(win.gold) == 40 and int(win.stars) == 3, "First normal win pays 40 gold")
	var replay: Dictionary = s.record_win("sun_seal", "", 1)
	check(not replay.first and int(replay.gold) == 10 and int(s.state.stars.sun_seal) == 3, "Replay pays 10 and keeps best stars")
	check(int(s.record_win("sapphire_cup", "HARD", 2).gold) == 80, "HARD pays 80")
	check(int(s.record_win("girl_with_a_pearl_earring", "SUPER HARD", 1).gold) == 120, "SUPER HARD pays 120")
	check(s.booster_count("extra_dock") == 0, "No gift before heist 4")
	s.record_win("starry_night", "", 3)
	check(s.booster_count("extra_dock") == 2 and s.state.tutorial.gift, "Heist 4 grants two Extra Docks once")
	s.record_win("mona_lisa", "", 3)
	check(s.booster_count("extra_dock") == 2, "Tutorial gift is not repeated")
	check(s.next_art(s.campaign.order()) == "moon_gate_mask", "Next heist follows campaign order")

	# Energy.
	s = store_at(path("energy"))
	check(s.has_energy(), "Full energy can play")
	for i in 10: s.spend_energy({})
	check(int(s.state.energy) == 0 and not s.has_energy(), "Ten failures empty the bar")
	check(s.seconds_to_next_energy() == 1200, "Next energy in 20 minutes")
	fake_now += 1200 * 3 + 5
	s.regenerate()
	check(int(s.state.energy) == 3, "Energy refills one per 20 minutes")
	fake_now += 1200 * 20
	s.regenerate()
	check(int(s.state.energy) == 10, "Refill stops at the cap")
	s.spend_energy({})
	s.apply(func(st): st.gold = 1000; return true)
	check(s.refill_energy_gold() and int(s.state.gold) == 100 and int(s.state.energy) == 10, "Gold refill costs 900")
	check(not s.refill_energy_gold(), "Cannot refill a full bar")

	# Boosters and gold.
	s = store_at(path("boosters"))
	check(not s.buy_booster("zap") and s.booster_count("zap") == 0, "200 starting gold cannot buy a 300-gold booster")
	s.apply(func(st): st.gold = 600; return true)
	check(s.buy_booster("scout_fly") and s.booster_count("scout_fly") == 1 and int(s.state.gold) == 300, "Booster costs 300 gold")
	check(s.use_booster("scout_fly", {}) and s.booster_count("scout_fly") == 0, "Using a booster spends stock")
	check(not s.use_booster("scout_fly", {}), "Zero stock cannot be used")
	check(not s.spend_gold(99999), "Cannot overspend gold")

	# Chests.
	s = store_at(path("chests"))
	check(s.daily_ready(), "Daily chest ready on first day")
	var daily: Dictionary = s.claim_daily()
	check(int(daily.day) == 0 and int(daily.gold) == 50 and not s.daily_ready(), "Day 1 pays 50, once per day")
	check(s.claim_daily().is_empty(), "Second claim the same day is refused")
	fake_now += 86400
	check(int(s.claim_daily().day) == 1, "Next day continues the streak")
	fake_now += 86400 * 3
	check(int(s.claim_daily().day) == 0, "Missed days restart the streak")
	check(s.star_chests_ready() == 0 and s.claim_star_chest().is_empty(), "No star chest before 10 stars")
	for art_id in ["sun_seal", "sapphire_cup", "girl_with_a_pearl_earring", "starry_night"]: s.record_win(art_id, "", 3)
	check(s.star_chests_ready() == 1, "Twelve stars open one star chest")
	var star: Dictionary = s.claim_star_chest()
	check(int(star.gold) == 100 and star.boosters.size() == 1 and s.star_chests_ready() == 0, "Star chest pays gold + one booster once")
	var chapter: Dictionary = s.campaign.chapter_by_number(1)
	check(not s.chapter_chest_ready(chapter), "Chapter chest waits for the finale")
	s.record_win("moon_gate_mask", "", 3)
	check(s.chapter_chest_ready(chapter), "Finale opens the chapter chest")
	check(s.unlocked_crew() == ["bit"], "Chapter 1 unlocks the first crew bug")
	var chest: Dictionary = s.claim_chapter_chest(chapter)
	check(int(chest.gold) == 200 and chest.boosters.size() == 2 and not s.chapter_chest_ready(chapter), "Chapter chest pays once")
	check(s.equip_crew("bit") and s.state.crew.equipped == "bit" and not s.equip_crew("dash"), "Only unlocked crew can be equipped")

	# Purchases and restore.
	s = store_at(path("shop"))
	var gold: int = int(s.state.gold)
	check(s.grant_purchase("coins_s", "txn-1") and int(s.state.gold) == gold + 1200, "Coins S grants 1,200 gold")
	check(s.grant_purchase("coins_s", "txn-1") and int(s.state.gold) == gold + 1200, "Same transaction never grants twice")
	check(s.grant_purchase("starter_pack", "txn-2") and s.owns("starter_pack") and s.unlimited_energy(), "Starter Pack: entitlement + unlimited energy")
	check(not s.product_available("starter_pack") and not s.grant_purchase("starter_pack", "txn-3"), "Starter Pack is once per player")
	check(s.booster_count("master_key") == 2, "Starter Pack adds two of each booster")
	s.spend_energy({})
	check(int(s.state.energy) == 10, "Unlimited energy is not spent")
	check(s.grant_purchase("no_ads", "txn-4") and s.no_ads(), "No Ads entitlement")
	s = store_at(path("restore"))
	check(s.restore_entitlement("no_ads") and s.no_ads() and int(s.state.gold) == 200, "Restore returns the entitlement only")
	check(not s.restore_entitlement("coins_m"), "Consumables are not restored")

	# Ads.
	s = store_at(path("ads"))
	for i in 5: check(not s.grant_ad_reward("free_coins", "ad-%d" % i).is_empty(), "Free coins %d" % i)
	check(s.grant_ad_reward("free_coins", "ad-9").is_empty() and s.free_coins_left() == 0, "Free coins cap at five per day")
	check(s.grant_ad_reward("energy", "ad-0").is_empty(), "One verified event grants once")
	fake_now += 86400
	check(s.free_coins_left() == 5, "Free coins reset the next day")
	for art_id in s.campaign.order().slice(0, 7): s.record_win(art_id, "", 3)
	check(not s.note_win_for_ads(), "No interstitial before heist 8")
	s.record_win(s.campaign.order()[7], "", 3)
	var shown := []
	for i in 4: shown.append(s.note_win_for_ads())
	check(shown == [false, true, false, false], "Interstitial at most every two heists and three minutes")
	fake_now += 200
	check(s.note_win_for_ads(), "Interstitial again after three minutes and two heists")
	s.grant_purchase("no_ads", "txn-x")
	check(not s.note_win_for_ads() and not s.note_win_for_ads(), "No Ads removes interstitials")

	# r12 (v1) migration: every acquired work joins the Gallery; credits -> gold.
	var v1_path := path("v1")
	var v1 := {"schema_version": 1, "generation": 7, "save_id": "0123456789abcdef0123456789abcdef",
		"acquired": {"sun_seal": {}, "mona_lisa": {}, "ivory_travel_clock": {}},
		"ownership": {"sun_seal": {"state": "owned"}, "mona_lisa": {"state": "sold"}},
		"wallet": {"credits": 7320}, "settings": {"sound": false, "tension_music": true, "reduced_motion": true}}
	AtomicStore.new().write(v1_path + ".v1", v1)
	s = store_at(v1_path)
	check(s.status == "migrated", "v1 save migrates")
	check(s.state.completed.has("sun_seal") and s.state.completed.has("mona_lisa"), "Sold r12 work still appears in the Gallery")
	check(not s.state.completed.has("ivory_travel_clock") and s.state.migration.dropped_art.has("ivory_travel_clock"), "Dropped candidates are recorded, not played")
	check(int(s.state.gold) == 200 + 7320, "Credits convert 1:1 to gold")
	check(not s.state.settings.sound and s.state.settings.reduced_motion and s.state.story.opening, "Settings carry over; opening already seen")
	check(FileAccess.file_exists(v1_path + ".v1"), "The v1 file is left untouched")
	check(store_at(v1_path).status == "loaded", "After migration the v2 save loads")

	# Pre-P02 ConfigFile migration.
	var legacy_path := path("legacy")
	LegacyStore.new().save_progress(legacy_path, {"completed": [0, 1, 5], "gallery_slots": [], "reduced_motion": false, "sound": true, "tension_music": false, "boost_remaining": 600.0})
	s = store_at(legacy_path)
	check(s.status == "migrated" and s.state.completed.size() == 3 and not s.state.settings.music, "Legacy config migrates completions and settings")

	# Validation refuses tampered state.
	var bad: Dictionary = s.state.duplicate(true)
	bad.energy = 99
	check(not s.validate(bad).is_empty(), "Energy above the cap is invalid")
	bad = s.state.duplicate(true)
	bad.entitlements = {"free_money": true}
	check(not s.validate(bad).is_empty(), "Unknown entitlement is invalid")

	print("R13 STORE CHECKS: %d | FAILURES: %d" % [checks, failures])
	quit(1 if failures > 0 else 0)
