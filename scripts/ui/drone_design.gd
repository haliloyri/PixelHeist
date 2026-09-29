@tool
extends RefCounted
## Carrier drone: one of the ten cube sprites from sc/assets/cube-asset.png (see
## cube_skin.gd), tinted to the artwork colour, with the capacity number on its top
## face. Two rotor arms stay hidden behind the cube and swing out from its sides.
## (2026-09-25: replaced the hive capsule body; backup in .backups/2026-09-25-cube-drones.)
const HV2 = preload("res://scripts/ui/game_theme.gd")
const CubeSkin = preload("res://scripts/ui/cube_skin.gd")
## Cube width relative to the carrier radius.
const CUBE_WIDTH := 1.25

static func _oval(center: Vector2, rx: float, ry: float, points: int=22) -> PackedVector2Array:
	var array:=PackedVector2Array()
	for i in points:
		var t:=TAU*float(i)/points
		array.append(center+Vector2(cos(t)*rx,sin(t)*ry))
	return array

static func paint(canvas:CanvasItem,point:Vector2,radius:float,tint:Color,heading:float=-PI/2,number:int=-1,alpha:float=1.0,rotor_phase:float=0,propellers:float=1.0)->void:
	canvas.draw_set_transform(point,heading+PI/2,Vector2.ONE*radius/54)
	var dark:=HV2.hv2_color("carrier","dark_contour","#223541");dark.a=alpha
	var shell:=HV2.hv2_color("carrier","enamel_shell","#F5F3E7");shell.a=alpha
	var color:=tint;color.a=alpha
	var spread:=smoothstep(0,1,propellers)
	# Two side-folding arms, one rotor each (the old four-corner layout is gone).
	if spread>.01:
		for side in [-1,1]:
			var root:=Vector2(side*22,-2)
			var hub:=root.lerp(Vector2(side*46,-6),spread)
			canvas.draw_line(root,hub,dark,9,true)
			canvas.draw_line(root,hub,shell,3,true)
			if spread>.55:
				for w in range(3):
					var gust:=Vector2(side*(4+w*4),16+w*4)
					canvas.draw_line(hub+Vector2(0,4)+gust*.4,hub+Vector2(0,4)+gust,Color(shell,.5*alpha*spread),1.4,true)
			canvas.draw_circle(hub,10*spread,dark)
			canvas.draw_arc(hub,8*spread,0,TAU,20,shell,2,true)
			canvas.draw_circle(hub,5*spread,Color(color,.7*alpha))
			var blade:=Vector2.RIGHT.rotated(rotor_phase+side*.6)*7*spread
			canvas.draw_line(hub-blade,hub+blade,shell,2.2,true)
			canvas.draw_circle(hub,1.8,dark)
	canvas.draw_set_transform(Vector2.ZERO)
	var texture:=CubeSkin.texture(tint)
	var cube_w:=radius*CUBE_WIDTH
	var h:=cube_w*float(texture.get_height())/float(texture.get_width())
	var turn:=heading+PI/2
	# Soft contact shadow, then the cube sprite itself.
	canvas.draw_set_transform(point+Vector2(0,h*.42).rotated(turn),turn,Vector2(1,.26))
	canvas.draw_circle(Vector2.ZERO,cube_w*.47,Color(.1,.09,.16,.20*alpha))
	canvas.draw_set_transform(point,turn,Vector2.ONE)
	canvas.draw_texture_rect(texture,Rect2(-cube_w*.5,-h*.5,cube_w,h),false,Color(1,1,1,alpha))
	if number>=0:
		var font:=ThemeDB.fallback_font
		var font_size:=int(cube_w*.36)
		var text:=str(number)
		var width:=font.get_string_size(text,HORIZONTAL_ALIGNMENT_LEFT,-1,font_size).x
		var at:=Vector2(-width*.5,-h*CubeSkin.TOP_FACE_LIFT+font.get_ascent(font_size)-font.get_height(font_size)*.5)
		canvas.draw_string_outline(font,at,text,HORIZONTAL_ALIGNMENT_LEFT,-1,font_size,5,dark)
		canvas.draw_string(font,at,text,HORIZONTAL_ALIGNMENT_LEFT,-1,font_size,Color("fffef8",alpha))
	canvas.draw_set_transform(Vector2.ZERO)

static func departure_pose(departure:Dictionary,duration:float)->Dictionary:
	var age:float=departure.age
	var lift:=smoothstep(.15,.75,age)
	var exit_progress:=smoothstep(.75,duration,age)
	var origin:Vector2=departure.position
	var target_x:float=-170 if int(departure.side)<0 else 890
	return {"position":Vector2(lerpf(origin.x,target_x,exit_progress),origin.y-40*lift),
		"radius":lerpf(float(departure.get("radius",78)),float(departure.get("radius",78))*1.8,lift),"heading":-PI/2+float(departure.side)*.18*exit_progress}
