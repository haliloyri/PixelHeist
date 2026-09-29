extends RefCounted
const UI=preload("res://scripts/ui/museum_controls.gd")
const Kit=preload("res://scripts/ui/ui_kit.gd")
const Art=preload("res://scripts/ui/reward_art.gd")
const L=preload("res://scripts/services/localization.gd")

static func receipt(game,data:Dictionary)->Array:
	var items:Array=[]
	if int(data.get("gold",0))>0:items.append({"id":"gold","name":"Gold","amount":"+"+L.number(int(data.gold))})
	var counts:Dictionary={}
	for id in data.get("boosters",[]):counts[id]=int(counts.get(id,0))+1
	var product:Dictionary=game.store.rules.products.get(data.get("product_id",""),{})
	for id in counts:
		var count:int=int(product.get("boosters",counts[id]))
		items.append({"id":id,"name":L.text(game.BOOSTER_NAMES[id]),"amount":"+%d"%count})
	if product.get("no_ads",false):items.append({"id":"no_ads","name":"No Ads","amount":"Unlocked"})
	if product.has("unlimited_energy_seconds"):items.append({"id":"energy","name":"Unlimited energy","amount":"%d min"%(int(product.unlimited_energy_seconds)/60)})
	if product.has("look"):items.append({"id":"look","name":"Special drone look","amount":"Unlocked"})
	return items

static func build(game,overlay:Control,data:Dictionary)->Panel:
	var daily:bool=data.get("kind","")=="daily"
	var items:Array=receipt(game,data)
	var rows:=ceili(items.size()/2.0)
	var top:=236.0+(112 if daily else 0)
	var height:=top+rows*80+124
	var title:String=L.text({"daily":"reward.daily","star":"reward.star","chapter":"reward.chapter","stage":"reward.stage","purchase":"reward.purchase"}.get(str(data.get("kind","")),"reward.title"))
	var card:=UI.modal(overlay,title,height,func():game._close_modal();game._refresh_current())
	var y:=110.0
	if daily:
		for day in 7:
			var active:=day==int(data.get("day",0))
			var box:=Kit.panel(card,Rect2(28+day*84,y,78,90),Color("087f72") if active else Color("163944"),Color("edc77e") if active else Color("496263"),2,12)
			UI.label(box,"DAY %d"%(day+1),Rect2(0,8,78,24),15,Color("fff0cb"),HORIZONTAL_ALIGNMENT_CENTER)
			UI.label(box,str(int(game.store.rules.daily[day].gold)),Rect2(0,36,78,26),22,Color("ffe5a0"),HORIZONTAL_ALIGNMENT_CENTER)
			UI.label(box,"Claimed" if active else "gold",Rect2(0,66,78,18),12,Color("fff0cb"),HORIZONTAL_ALIGNMENT_CENTER)
		y+=112
	var kind:String={"star":"stars","chapter":"chapter","stage":"chapter","purchase":"offer","ad":"coins"}.get(str(data.get("kind","")),"daily")
	if data.get("product_id","") in ["no_ads","no_ads_pack"]:kind="no_ads"
	var chest:=Art.attach(card,kind,Rect2(24,y-12,148,136))
	chest.name="Chest"
	UI.label(card,"Added to your stash",Rect2(182,y+20,412,38),27,Color("ffe5a0"))
	UI.label(card,str(data.get("title","Your next heist is waiting.")),Rect2(182,y+62,412,42),19,Color("c9b58c"),HORIZONTAL_ALIGNMENT_LEFT,true)
	for i in items.size():
		var item:Dictionary=items[i]
		var tile:=Kit.panel(card,Rect2(28+(i%2)*302,top+(i/2)*80,282,68),Color("163944"),Color("496263"),1,14)
		tile.name="Reward_"+item.id
		UI.label(tile,item.name,Rect2(16,8,252,25),19)
		UI.label(tile,item.amount,Rect2(16,34,252,25),23,Color("ffe5a0"))
	UI.button(card,L.text("ui.collect"),Rect2(28,height-94,584,68),func():game._close_modal();game._refresh_current(),true,28).name="Collect"
	var celebration:=preload("res://scripts/ui/reward_celebration.gd").new()
	celebration.name="Celebration";card.add_child(celebration)
	celebration.position=Vector2(0,y-6)
	celebration.size=Vector2(640,height-114-celebration.position.y)
	celebration.start(game,chest)
	return card
