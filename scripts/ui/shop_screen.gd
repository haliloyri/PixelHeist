extends Control
## S6 Shop (design r13 sections 9 and 14): featured offer, No Ads, Coins, Boosters (gold),
## Looks (gold) and Restore Purchases. Real-money items go through the commerce provider.
const Kit = preload("res://scripts/ui/ui_kit.gd")
const L = preload("res://scripts/services/localization.gd")
const TOOLS := ["res://assets/toolbar/tool_0_ant_plus.png", "res://assets/toolbar/tool_1_ray_gun.png", "res://assets/toolbar/tool_2_fly.png", "res://assets/toolbar/tool_3_key_blueprint.png"]
var game
var list: VBoxContainer
var scroll: ScrollContainer

func setup(controller) -> void:
	game = controller
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_STOP
	refresh()

func refresh() -> void:
	var offset := 0.0
	if is_instance_valid(scroll): offset = scroll.scroll_vertical
	for child in get_children(): child.queue_free()
	Kit.background(self, .45)
	Kit.ribbon(self, L.text("shop.title"), Vector2(360, 70), 340, 36)
	var bar := Kit.panel(self, Rect2(230, 124, 260, 60), Color("24160c"), Kit.COPPER, 3, 30)
	Kit.coin(bar, Vector2(36, 30), 20)
	var gold := Kit.label(bar, L.number(int(game.store.state.gold)), Rect2(64, 0, 180, 60), 30, Kit.GOLD, 5, HORIZONTAL_ALIGNMENT_LEFT)
	gold.name = "Gold"
	scroll = ScrollContainer.new()
	scroll.name = "Scroll"
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	add_child(scroll)
	scroll.anchor_right = 1.0
	scroll.anchor_bottom = 1.0
	scroll.offset_top = 200
	scroll.offset_bottom = -118
	list = VBoxContainer.new()
	list.custom_minimum_size = Vector2(720, 0)
	list.add_theme_constant_override("separation", 14)
	scroll.add_child(list)
	var featured: String = game.featured_offer()
	if featured != "": _product_row(featured, true)
	_heading("shop.no_ads")
	_product_row("no_ads")
	_product_row("no_ads_pack")
	_heading("shop.coins")
	for id in ["coins_s", "coins_m", "coins_l"]: _product_row(id)
	_heading("shop.boosters")
	for i in game.BOOSTERS.size(): _booster_row(i)
	_heading("shop.looks")
	for id in game.store.rules.looks:
		if int(game.store.rules.looks[id].price) >= 0 or game.store.state.looks.owned.has(id): _look_row(id)
	var restore := _row(80)
	Kit.button(restore, L.text("shop.restore"), Rect2(210, 10, 300, 60), game.restore_purchases, "secondary", 22).name = "Restore"
	Kit.nav(self, game, "shop")
	scroll.set_deferred("scroll_vertical", offset)

func _row(height: float) -> Control:
	var row := Control.new()
	row.custom_minimum_size = Vector2(720, height)
	row.mouse_filter = Control.MOUSE_FILTER_PASS
	list.add_child(row)
	return row

func _heading(key: String) -> void:
	var row := _row(56)
	Kit.label(row, L.upper(L.text(key)), Rect2(50, 8, 620, 44), 28, Kit.GOLD, 6, HORIZONTAL_ALIGNMENT_LEFT)

func _product_row(id: String, featured: bool = false) -> void:
	var product: Dictionary = game.store.rules.products[id]
	var row := _row(150 if featured else 120)
	var card := Kit.panel(row, Rect2(40, 0, 640, row.custom_minimum_size.y), Color("5a2e18") if featured else Kit.WOOD, Kit.GOLD if featured else Kit.COPPER, 5, 22)
	card.name = "Product_" + id
	Kit.image(card, "res://assets/lobby/chest_gems.png" if not id.begins_with("coins") else "res://assets/lobby/gem_r1.png", Rect2(14, 10, 100, card.size.y - 20))
	Kit.label(card, product.name, Rect2(124, 10, 300, 44), 28, Kit.CREAM, 5, HORIZONTAL_ALIGNMENT_LEFT)
	var parts: Array = []
	if product.has("gold"): parts.append(L.number(int(product.gold)) + " " + L.text("lobby.gold"))
	if product.has("boosters"): parts.append(L.text("offer.boosters", {"count": L.number(int(product.boosters))}))
	if product.has("unlimited_energy_seconds"): parts.append(L.text("offer.energy"))
	if product.get("no_ads", false): parts.append(L.text("offer.no_ads"))
	Kit.label(card, ", ".join(parts), Rect2(124, 52, 330, card.size.y - 60), 20, Kit.MUTED, 3, HORIZONTAL_ALIGNMENT_LEFT, true)
	if game.store.product_available(id):
		Kit.button(card, product.price, Rect2(462, card.size.y * .5 - 34, 160, 68), game.buy_product.bind(id), "green", 26).name = "Buy"
	else:
		Kit.label(card, L.text("shop.owned_label"), Rect2(462, 0, 160, card.size.y), 26, Kit.GOLD, 5)

func _booster_row(i: int) -> void:
	var id: String = game.BOOSTERS[i]
	var row := _row(110)
	var card := Kit.panel(row, Rect2(40, 0, 640, 110), Kit.WOOD, Kit.COPPER, 4, 22)
	card.name = "Booster_" + id
	if i < TOOLS.size():
		Kit.image(card, TOOLS[i], Rect2(14, 10, 90, 90))
	else:
		var icon := TextureRect.new()
		icon.texture = preload("res://scripts/ui/heist_skin.gd").icon(1)
		icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		icon.position = Vector2(14,10); icon.size = Vector2(90,90)
		card.add_child(icon)
	Kit.label(card, L.text(game.BOOSTER_NAMES[id]), Rect2(116, 8, 330, 40), 26, Kit.CREAM, 5, HORIZONTAL_ALIGNMENT_LEFT)
	Kit.label(card, L.text("shop.owned_count", {"count": L.number(game.store.booster_count(id))}), Rect2(116, 50, 330, 40), 20, Kit.MUTED, 3, HORIZONTAL_ALIGNMENT_LEFT)
	var price: int = int(game.store.rules.booster_price)
	var b := Kit.button(card, L.number(price), Rect2(462, 21, 160, 68), _buy_booster.bind(id), "green" if int(game.store.state.gold) >= price else "disabled", 26)
	b.name = "Buy"
	Kit.coin(b, Vector2(26, 34), 14)

func _buy_booster(id: String) -> void:
	if game.store.buy_booster(id): game.toast("booster.bought", {"name": L.text(game.BOOSTER_NAMES[id])})
	refresh()

func _look_row(id: String) -> void:
	var look: Dictionary = game.store.rules.looks[id]
	var row := _row(100)
	var card := Kit.panel(row, Rect2(40, 0, 640, 100), Kit.WOOD, Kit.COPPER, 4, 22)
	card.name = "Look_" + id
	Kit.image(card, "res://assets/lobby/drone.png" if look.slot == "drone" else "res://assets/drones/cube_00_brown.png", Rect2(14, 8, 110, 84))
	Kit.label(card, look.name, Rect2(136, 0, 310, 100), 26, Kit.CREAM, 5, HORIZONTAL_ALIGNMENT_LEFT)
	var owned: bool = game.store.state.looks.owned.has(id)
	var equipped: bool = game.store.state.looks.equipped.get(look.slot, "") == id
	if equipped:
		Kit.label(card, L.text("gallery.equipped"), Rect2(462, 0, 160, 100), 24, Kit.GOLD, 4)
	elif owned:
		Kit.button(card, L.text("gallery.equip"), Rect2(462, 16, 160, 68), func(): game.store.equip_look(id); refresh(), "secondary", 24)
	else:
		var price: int = int(look.price)
		var b := Kit.button(card, L.number(price), Rect2(462, 16, 160, 68), func(): game.store.buy_look(id); refresh(), "green" if int(game.store.state.gold) >= price else "disabled", 24)
		Kit.coin(b, Vector2(26, 34), 14)
