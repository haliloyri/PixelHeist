extends SceneTree
const Fixture=preload("res://tests/fixture.gd")
const Receipt=preload("res://scripts/ui/reward_panel.gd")
const Store=preload("res://scripts/services/progress_store.gd")
var checks:=0
var failures:=0
func check(ok:bool,label:String)->void:
	checks+=1
	if not ok:failures+=1;printerr("FAIL: ",label)
func _initialize()->void:call_deferred("run")
func run()->void:
	var game=Fixture.create_game();root.add_child(game);await process_frame
	game.set_process(false)
	game.store.apply(func(s):s.story.opening=true;return true)
	game._show_lobby();game._show_modal("settings")
	var card:Panel=game.overlay.get_node("Card")
	var initial:Dictionary=game.store.state.settings.duplicate()
	for key in initial:
		if key not in ["sound","music","vibration","reduced_motion"]:continue
		game._toggle_setting(key)
		check(game.overlay.get_node("Card")==card,"Setting changes in place: "+key)
		check(game.store.state.settings[key]!=initial[key] and card.get_node("Toggle_"+key).button_pressed==game.store.state.settings[key],"Switch reflects saved state: "+key)
	var reopened:=Store.new();reopened.open(game.save_path)
	check(reopened.state.settings==game.store.state.settings,"Settings persist across reload")
	game.store.read_only=true
	var before:Dictionary=game.store.state.settings.duplicate()
	game._toggle_setting("sound")
	check(game.store.state.settings==before and game.sound_enabled==before.sound and card.get_node("Toggle_sound").button_pressed==before.sound,"Failed setting write preserves runtime and displayed state")
	game.store.read_only=false
	card.get_node("Done").pressed.emit()
	check(game.modal_kind.is_empty(),"Done closes Settings")
	var home=game.screen_view
	home._toggle_rewards()
	check(home.rewards.visible and home.reward_buttons.daily.get_node("Action").text=="Collect","Ready daily reward has a clear action")
	check(home.reward_buttons.stars.disabled and home.reward_buttons.chapter.disabled,"Locked chests cannot trigger empty claims")
	check(home.reward_buttons.coins.get_node("Action").text=="Watch Ad","Free coins explicitly require watching an ad")
	var escape:=InputEventAction.new();escape.action="ui_cancel";escape.pressed=true
	home._input(escape)
	check(not home.rewards.visible and home.shortcuts.daily.has_focus(),"Escape closes rewards and restores trigger focus")
	home._toggle_rewards();home.rewards.get_node("Dismiss").pressed.emit()
	check(not home.rewards.visible,"Outside tap dismisses rewards")
	home._toggle_rewards();home.reward_buttons.daily.pressed.emit()
	check(game.modal_kind=="reward" and not home.rewards.visible,"Daily claim opens only one reward surface")
	var gold:int=game.store.state.gold
	game.overlay.get_node("Card/Collect").pressed.emit()
	check(game.modal_kind.is_empty() and game.store.state.gold==gold,"Collect acknowledges the existing grant without granting twice")
	home._toggle_rewards()
	check(home.reward_buttons.daily.disabled and home.reward_buttons.daily.get_node("Action").text=="Claimed","Claimed daily state refreshes")
	home._close_rewards()
	var rewards:Array=Receipt.receipt(game,{"gold":50,"boosters":["zap","zap","row_beam"]})
	check(rewards.size()==3 and rewards[1].amount=="+2","Repeated boosters group into truthful quantities")
	var purchase:Dictionary={"kind":"purchase","product_id":"starter_pack","gold":1000,"boosters":game.BOOSTERS}
	rewards=Receipt.receipt(game,purchase)
	check(rewards.size()==7 and rewards[1].amount=="+2" and rewards.back().amount=="60 min","Starter receipt includes exact booster counts and energy duration")
	rewards=Receipt.receipt(game,{"kind":"purchase","product_id":"no_ads"})
	check(rewards.size()==1 and rewards[0].id=="no_ads","No Ads receipt shows entitlement instead of +0 gold")
	game._show_reward(purchase)
	card=game.overlay.get_node("Card")
	check(card.get_node("Reward_scout_fly").size.x>0 and card.get_node("Collect").get_rect().end.y<card.size.y,"Longest receipt keeps Collect within its panel")
	game._close_modal()
	game.reduced_motion=false
	game._show_reward(purchase);card=game.overlay.get_node("Card")
	var celebration=card.get_node("Celebration");celebration.set_process(false)
	check(celebration.pieces.size()==56 and celebration.mouse_filter==Control.MOUSE_FILTER_IGNORE,"Reward confetti is bounded and cannot intercept taps")
	check(celebration.get_rect().end.y<card.get_node("Collect").position.y and celebration.position.y>card.get_node("Close").get_rect().end.y,"Reward confetti excludes Close and Collect")
	check(not card.get_node("Collect").disabled,"Collect remains immediately available during celebration")
	celebration.advance(.2)
	check(card.get_node("Chest").scale.x>1,"Reward chest briefly pops with the burst")
	game.app_suspended=true;celebration._process(.5)
	check(is_equal_approx(celebration.age,.2),"Reward celebration freezes while app is suspended")
	game.app_suspended=false;celebration._process(.2)
	check(is_equal_approx(celebration.age,.4),"Reward celebration resumes without restarting")
	celebration.advance(5)
	check(not celebration.is_processing() and celebration.visible_piece_count()==0 and card.get_node("Chest").scale==Vector2.ONE,"Reward celebration settles and stops processing")
	gold=game.store.state.gold;card.get_node("Collect").pressed.emit();await process_frame
	check(not is_instance_valid(celebration) and game.store.state.gold==gold,"Dismissing celebration frees it without another reward grant")
	game.reduced_motion=true;game._show_reward(purchase);card=game.overlay.get_node("Card")
	celebration=card.get_node("Celebration")
	check(celebration.pieces.is_empty() and not celebration.is_processing() and card.get_node("Chest").scale==Vector2.ONE,"Reduced motion disables reward particles and chest motion")
	game._close_modal();game.reduced_motion=false
	game._show_gallery("crew")
	var museum=game.screen_view
	var rows:Control=museum.content.get_node("CrewScroll/Rows")
	check(rows.get_child_count()==10,"Every crew member is reachable in a scrolling list")
	check(rows.get_node("Crew_bit").get_node_or_null("Equip")==null,"Locked crew cannot equip")
	for id in game.campaign.order():game.store.record_win(id,"",3)
	museum.refresh();rows=museum.content.get_node("CrewScroll/Rows")
	var unlocked:Array=game.store.unlocked_crew()
	check(not unlocked.is_empty(),"Earned crew become available")
	var chosen:String=unlocked.back()
	rows.get_node("Crew_"+chosen+"/Equip").pressed.emit()
	check(game.store.state.crew.equipped==chosen and museum.content.get_node("CrewScroll/Rows/Crew_"+chosen+"/Equip").disabled,"Equipped state updates after persistence")
	game.store.read_only=true
	museum._equip(unlocked[0])
	check(game.store.state.crew.equipped==chosen,"Failed equip keeps the existing member")
	game.store.read_only=false
	game._show_lobby();home=game.screen_view;home._toggle_rewards()
	check(not home.reward_buttons.stars.disabled and not home.reward_buttons.chapter.disabled,"Earned star and milestone chests become actionable")
	for chapter in game.campaign.chapters:game.store.claim_chapter_chest(chapter)
	# Unauthored chapters remain incomplete; a completed-campaign fixture uses
	# the authored chapter set after every one of its chests has been claimed.
	var all_chapters:Array=game.campaign.chapters
	game.campaign.chapters=all_chapters.filter(func(chapter):return game.store.chapter_complete(chapter))
	home._refresh_rewards()
	check(home.reward_buttons.chapter.disabled and home.reward_buttons.chapter.get_node("Status").text=="All milestones collected","Finished campaign does not prompt replaying a completed milestone")
	game.campaign.chapters=all_chapters
	home._close_rewards()
	game._replay_artwork("sun_seal");game._show_modal("pause")
	card=game.overlay.get_node("Card")
	check(card.has_node("Resume") and card.has_node("QuitHeist") and card.has_node("Booster_scout_fly") and card.has_node("Booster_master_key"),"Pause preserves resume, energy-cost exit and legacy boosters")
	game._toggle_setting("music")
	check(game.overlay.get_node("Card")==card and game.modal_kind=="pause","Pause switch retains the same paused panel")
	card.get_node("Resume").pressed.emit()
	check(game.screen=="play" and game.modal_kind.is_empty(),"Resume returns to the heist")
	Fixture.cleanup(game);game.queue_free();await process_frame
	print("SCREEN REFRESH CHECKS: %d | FAILURES: %d"%[checks,failures])
	quit(1 if failures else 0)
