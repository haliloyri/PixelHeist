extends Control
## HUD-free composition shared by the live room and high-resolution photo export.
const ArtView=preload("res://scripts/ui/museum_art.gd")
const Kit=preload("res://scripts/ui/ui_kit.gd")
const L=preload("res://scripts/services/localization.gd")
const FONT=preload("res://assets/fonts/Lora-700.ttf")
const MUSEUM=preload("res://assets/heist_v4/museum.png")
const THEMES={"midnight":Color("102a3b"),"emerald":Color("103a31"),"burgundy":Color("3e1c2b")}
const LAYOUTS={"spotlight":"Spotlight + pairs","pairs":"Two per row","salon":"Three per row"}
signal artwork_pressed(art_id:String)
var wall:=Color("102a3b")
var artwork_rects:Array[Rect2]=[]

static func live_height(count:int,layout:String,width:float)->float:
	var hero:=layout=="spotlight" and count>1
	var columns:=3 if layout=="salon" else 2
	var rows:=ceili(float(count-(1 if hero else 0))/columns)
	return maxf(800,204+rows*250+(340 if hero else 0))*width/720.0

static func arrangement(count:int,layout:String,extent:Vector2)->Array[Rect2]:
	var rects:Array[Rect2]=[]
	if count==0:return rects
	var k:=extent.x/720.0
	var top:=140*k
	var bottom:=extent.y-64*k
	if count==1:
		rects.append(Rect2(78*k,top,extent.x-156*k,bottom-top))
		return rects
	var hero:=layout=="spotlight"
	var cols:=3 if layout=="salon" else 2
	var remaining:=count-(1 if hero else 0)
	var rows:=ceili(float(remaining)/cols)
	var gap:=20*k
	var row_height:float=(bottom-top-gap*(rows if hero else rows-1))/(rows+(1.5 if hero else 0.0))
	if hero:
		var hero_height:=row_height*1.5
		rects.append(Rect2(105*k,top,extent.x-210*k,hero_height))
		top+=hero_height+gap
	# Tight export rows should not scatter small paintings across a wide empty wall.
	var col_width:float=minf((extent.x-64*k-gap*(cols-1))/cols,row_height*1.5)
	var grid_left:float=(extent.x-cols*col_width-(cols-1)*gap)*.5
	for i in remaining:
		var in_row:=mini(cols,remaining-(i/cols)*cols)
		var offset:float=(cols-in_row)*(col_width+gap)*.5
		rects.append(Rect2(grid_left+(i%cols)*(col_width+gap)+offset,top+(i/cols)*(row_height+gap),col_width,row_height))
	return rects

func setup(game, collection: Dictionary, pixels: bool, extent: Vector2, editing:=false, selected:="")->void:
	size=extent
	mouse_filter=Control.MOUSE_FILTER_PASS if editing else Control.MOUSE_FILTER_IGNORE
	clip_contents=true
	wall=THEMES.get(collection.theme,THEMES.midnight)
	var k:=extent.x/720.0
	var title:=Kit.label(self,collection.title,Rect2(32*k,28*k,extent.x-64*k,62*k),roundi(34*k),Color("f7e6be"),1)
	title.name="CollectionTitle"
	title.add_theme_font_override("font",FONT)
	L.fit(title,roundi(34*k),roundi(22*k))
	var subtitle:=L.text("museum.pixel_edition") if pixels else L.text("museum.private_collection")
	var sub:=Kit.label(self,subtitle.to_upper(),Rect2(30*k,92*k,extent.x-60*k,26*k),roundi(14*k),Color("c9b58c"),0)
	sub.add_theme_font_override("font",FONT)
	var ids:Array=collection.art_ids
	artwork_rects=arrangement(ids.size(),collection.get("layout","spotlight"),extent)
	if ids.is_empty():
		Kit.label(self,L.text("museum.empty_room"),Rect2(60*k,extent.y*.42,extent.x-120*k,90*k),roundi(28*k),Kit.CREAM,1,HORIZONTAL_ALIGNMENT_CENTER,true)
	for i in ids.size():
		var rect:Rect2=artwork_rects[i]
		var art:=ArtView.new()
		art.name="Artwork%d"%i
		add_child(art)
		art.position=rect.position
		art.setup(game,ids[i],pixels,rect.size)
		if editing:
			var hit:=Button.new()
			hit.name="Place_"+str(ids[i])
			hit.tooltip_text="Select "+game.art_title(ids[i])+" to move or swap"
			hit.set_meta("accessible_label",hit.tooltip_text)
			hit.mouse_default_cursor_shape=Control.CURSOR_POINTING_HAND
			for state in ["normal","hover","pressed","focus"]:
				var active:bool=ids[i]==selected or state=="focus"
				var skin:=Kit.panel_style(Color(.1,.8,.7,.08 if state=="hover" else 0),Color("38dbc3") if active else Color.TRANSPARENT,3,12)
				skin.shadow_size=0
				hit.add_theme_stylebox_override(state,skin)
			add_child(hit)
			hit.position=rect.position;hit.size=rect.size
			hit.pressed.connect(func():artwork_pressed.emit(ids[i]))
			var badge:=Kit.panel(hit,Rect2(4,4,34,30),Color("102a35"),Color("38dbc3") if ids[i]==selected else Color("c6a16a"),1,8)
			Kit.label(badge,str(i+1),Rect2(0,0,34,30),17,Kit.CREAM,0)
	Kit.label(self,"PIXEL HEIST",Rect2(0,extent.y-44*k,extent.x,24*k),roundi(16*k),Color("d3bd8d"),0)
	queue_redraw()
func _draw()->void:
	draw_texture_rect(MUSEUM,Rect2(Vector2.ZERO,size),false)
	draw_polygon(PackedVector2Array([Vector2.ZERO,Vector2(size.x,0),size,Vector2(0,size.y)]),PackedColorArray([Color(wall,.83),Color(wall,.83),Color(wall.darkened(.75),.94),Color(wall.darkened(.75),.94)]))
	var k:=size.x/720.0
	for x in [14.0,706.0]:
		draw_line(Vector2(x*k,0),Vector2(x*k,size.y),wall.lightened(.13),8*k)
		draw_line(Vector2((x+3)*k,0),Vector2((x+3)*k,size.y),Color("967447"),k)
	draw_line(Vector2(40*k,124*k),Vector2(size.x-40*k,124*k),Color("94734c"),k)
	draw_line(Vector2(40*k,size.y-54*k),Vector2(size.x-40*k,size.y-54*k),Color("94734c"),k)
