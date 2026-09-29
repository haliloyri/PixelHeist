extends Control
## Crisp, scalable symbols for the Museum's icon-only controls.
var kind := "museum"
var selected := false
const ILLUSTRATED_ICONS=preload("res://assets/ui/museum/illustrated_icons.png")
var illustrated := false
var relief := false
var relief_shadow := false
const GOLD := Color("c6a16a")
const IVORY := Color("f4e8cf")
const EMERALD := Color("8af1df")

static func attach(button:Button,icon_kind:String,label:String,is_selected:=false,use_illustration:=false)->Button:
	button.text=""
	button.tooltip_text=label
	button.set_meta("accessible_label",label)
	var art:=new()
	art.name="Icon"
	art.kind=icon_kind
	art.selected=is_selected
	art.illustrated=use_illustration
	art.relief=use_illustration
	art.mouse_filter=Control.MOUSE_FILTER_IGNORE
	button.add_child(art)
	var edge:=minf(button.size.x,button.size.y)-12.0
	art.position=(button.size-Vector2.ONE*edge)*.5
	art.size=Vector2.ONE*edge
	return button

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE

func _line(points: PackedVector2Array, color: Color, width := 3.5) -> void:
	draw_polyline(points, color, width, true)

func _draw() -> void:
	var regions:={"floors":Rect2(32,32,480,448),"collection":Rect2(523,32,500,444),"crew":Rect2(1025,66,500,430),"pixels":Rect2(32,512,460,440),"elevator":Rect2(548,484,440,478),"photo":Rect2(1035,550,478,392)}
	if illustrated and regions.has(kind):
		var sheet:Texture2D=ILLUSTRATED_ICONS
		var region:Rect2=regions[kind]
		var extent:=region.size*minf(size.x/region.size.x,size.y/region.size.y)
		draw_texture_rect_region(sheet,Rect2((size-extent)*.5,extent),region)
		return
	if relief:
		relief_shadow=true
		_draw_symbol(Vector2(0,3))
		relief_shadow=false
	_draw_symbol(Vector2.ZERO)

func _draw_symbol(offset:Vector2) -> void:
	var k: float = minf(size.x, size.y) / 64.0
	draw_set_transform((size - Vector2(64,64)*k)*.5+offset, 0.0, Vector2.ONE*k)
	var ink: Color = Color("49331a") if relief_shadow else (EMERALD if selected else Color("edc77e") if relief else IVORY)
	match kind:
		"floors":
			for i in 3:
				var y: float = 12.0 + i*17.0
				draw_rect(Rect2(12,y,40,12),ink,false,3)
				draw_line(Vector2(20,y+6),Vector2(44,y+6),GOLD,2)
		"elevator":
			draw_rect(Rect2(14,8,36,49),ink,false,3)
			draw_line(Vector2(32,11),Vector2(32,54),GOLD,2)
			_line(PackedVector2Array([Vector2(25,25),Vector2(21,19),Vector2(17,25)]),ink,2.5)
			_line(PackedVector2Array([Vector2(47,38),Vector2(43,44),Vector2(39,38)]),ink,2.5)
		"collection":
			draw_rect(Rect2(9,15,30,37),GOLD,false,3)
			draw_rect(Rect2(24,9,31,39),ink,false,3)
			_line(PackedVector2Array([Vector2(29,39),Vector2(37,30),Vector2(42,35),Vector2(50,25)]),ink,3)
			draw_circle(Vector2(35,20),3,GOLD)
		"crew", "equip":
			draw_circle(Vector2(32,18),6,ink)
			draw_circle(Vector2(32,32),9,ink)
			draw_circle(Vector2(32,47),7,ink)
			for side in [-1,1]:
				_line(PackedVector2Array([Vector2(27+side*1,27),Vector2(15+side*2 if side<0 else 49,23),Vector2(7 if side<0 else 57,19)]),ink,2.5)
				_line(PackedVector2Array([Vector2(27 if side<0 else 37,38),Vector2(12 if side<0 else 52,43),Vector2(7 if side<0 else 57,51)]),ink,2.5)
			_line(PackedVector2Array([Vector2(29,13),Vector2(24,6)]),GOLD,2.5)
			_line(PackedVector2Array([Vector2(35,13),Vector2(40,6)]),GOLD,2.5)
			if kind=="equip":draw_circle(Vector2(50,48),8,EMERALD)
		"shop":
			draw_rect(Rect2(13,22,38,33),ink,false,3)
			draw_arc(Vector2(32,22),11,PI,TAU,18,ink,3,true)
			draw_line(Vector2(13,32),Vector2(51,32),GOLD,2)
		"home":
			_line(PackedVector2Array([Vector2(7,30),Vector2(32,9),Vector2(57,30)]),ink,4)
			draw_rect(Rect2(14,29,36,27),ink,false,3)
			draw_rect(Rect2(27,39,10,17),GOLD,false,2)
		"museum":
			_line(PackedVector2Array([Vector2(7,22),Vector2(32,8),Vector2(57,22),Vector2(7,22)]),ink,3)
			for x in [15,29,43]:draw_rect(Rect2(x,26,7,25),ink,false,2.5)
			draw_line(Vector2(8,55),Vector2(56,55),GOLD,3)
		"pixels":
			for row in 4:
				for col in 4:
					draw_rect(Rect2(10+col*12,10+row*12,9,9),EMERALD if (row+col)%3==0 else ink,true)
		"original":
			draw_rect(Rect2(7,11,50,42),ink,false,3)
			draw_circle(Vector2(43,22),5,GOLD)
			_line(PackedVector2Array([Vector2(11,46),Vector2(24,30),Vector2(33,40),Vector2(41,34),Vector2(53,47)]),ink,3)
		"layout_spotlight", "layout_pairs", "layout_salon":
			var columns:=3 if kind=="layout_salon" else 2
			var top:=10.0
			if kind=="layout_spotlight":
				draw_rect(Rect2(19,7,26,19),ink,false,3)
				top=33
			var width:float=44.0/columns-4
			for row in (1 if kind=="layout_spotlight" else 2):
				for col in columns:
					draw_rect(Rect2(12+col*(width+4),top+row*25,width,18),ink,false,2.5)
		"left":_line(PackedVector2Array([Vector2(39,11),Vector2(19,32),Vector2(39,53)]),ink,5)
		"right":_line(PackedVector2Array([Vector2(25,11),Vector2(45,32),Vector2(25,53)]),ink,5)
		"back":
			_line(PackedVector2Array([Vector2(33,12),Vector2(13,32),Vector2(33,52)]),ink,4)
			draw_line(Vector2(14,32),Vector2(55,32),ink,4)
		"close":
			draw_line(Vector2(15,15),Vector2(49,49),ink,4)
			draw_line(Vector2(49,15),Vector2(15,49),ink,4)
		"edit":
			_line(PackedVector2Array([Vector2(13,47),Vector2(45,15),Vector2(52,22),Vector2(20,54),Vector2(13,54),Vector2(13,47)]),ink,3)
			draw_line(Vector2(39,21),Vector2(46,28),GOLD,2)
		"palette":
			draw_arc(Vector2(31,31),23,-PI*.9,PI*.75,24,ink,3,true)
			draw_circle(Vector2(19,22),5,GOLD)
			draw_circle(Vector2(32,15),5,EMERALD)
			draw_circle(Vector2(45,24),5,Color("a87980"))
			draw_circle(Vector2(22,40),5,IVORY)
			draw_circle(Vector2(43,45),8,Color("0b1924"))
		"photo":
			draw_rect(Rect2(7,19,50,35),ink,false,3)
			draw_rect(Rect2(15,13,17,7),ink,false,2)
			draw_circle(Vector2(34,37),11,ink,false,3)
			draw_circle(Vector2(34,37),4,GOLD)
		"save":
			draw_line(Vector2(32,8),Vector2(32,40),ink,4)
			_line(PackedVector2Array([Vector2(19,29),Vector2(32,42),Vector2(45,29)]),ink,4)
			_line(PackedVector2Array([Vector2(10,46),Vector2(10,55),Vector2(54,55),Vector2(54,46)]),GOLD,3)
		"crop":
			_line(PackedVector2Array([Vector2(10,26),Vector2(10,10),Vector2(26,10)]),ink,3)
			_line(PackedVector2Array([Vector2(38,10),Vector2(54,10),Vector2(54,26)]),ink,3)
			_line(PackedVector2Array([Vector2(10,38),Vector2(10,54),Vector2(26,54)]),ink,3)
			_line(PackedVector2Array([Vector2(38,54),Vector2(54,54),Vector2(54,38)]),ink,3)
		"done":_line(PackedVector2Array([Vector2(12,33),Vector2(26,46),Vector2(53,17)]),ink,5)
		"add":
			draw_circle(Vector2(32,32),24,GOLD,false,2.5)
			draw_line(Vector2(18,32),Vector2(46,32),ink,4)
			draw_line(Vector2(32,18),Vector2(32,46),ink,4)
		"remove":
			draw_circle(Vector2(32,32),24,GOLD,false,2.5)
			draw_line(Vector2(18,32),Vector2(46,32),ink,4)
		"feature":
			var points:=PackedVector2Array()
			for i in 10:
				var a:float=-PI*.5+i*PI/5.0
				var r:float=24.0 if i%2==0 else 11.0
				points.append(Vector2(32,32)+Vector2(cos(a),sin(a))*r)
			draw_colored_polygon(points,GOLD)
	draw_set_transform(Vector2.ZERO,0.0,Vector2.ONE)
