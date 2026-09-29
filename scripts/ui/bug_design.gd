@tool
extends RefCounted
## "Bit" — the ladybug thieves that replace the old flying scout silhouette.
## Red pixel-tiled dome shell, black robber mask, big LED eyes, thick contour.
## Presentation only: position/heading/timing still come from drone_routes.gd
## and the existing flight simulation; this file only changes how a scout is drawn.
const HV2 = preload("res://scripts/ui/game_theme.gd")

static func paint(canvas: CanvasItem, point: Vector2, size: float, heading: float=-PI/2, alpha: float=1.0, walk_phase: float=0.0, shell_open: float=0.0) -> void:
	var scale: float = size/60.0
	var contour:=HV2.hv2_color("bug","contour","#20242B");contour.a=alpha
	var shell:=HV2.hv2_color("bug","shell_red","#E23B3B");shell.a=alpha
	var mask:=HV2.hv2_color("bug","mask_black","#20242B");mask.a=alpha
	var led:=HV2.hv2_color("bug","eye_led","#7CF7FF");led.a=alpha
	var white:=Color(1,1,1,alpha)
	canvas.draw_set_transform(point,heading+PI/2,Vector2.ONE*scale)
	# Ground contact shadow, walking legs (two-frame oscillation, no flight-height growth).
	canvas.draw_colored_polygon(_oval(Vector2(0,26),22,7),Color(.1,.09,.1,.20*alpha))
	var swing:=sin(walk_phase)*6.0
	for side in [-1,1]:
		for i in [0,1]:
			var lift:=sin(walk_phase+i*PI+side*.6)*4.0
			var root:=Vector2(side*16,4+i*10)
			var foot:=root+Vector2(side*10,16+lift*.4)
			canvas.draw_line(root,foot,contour,4,true)
	# Black body base under the shell.
	canvas.draw_colored_polygon(_oval(Vector2.ZERO,26,22),mask)
	# Two big round LED eyes with thick contour, forward of centre.
	for side in [-1,1]:
		var eye:=Vector2(side*11,-16)
		canvas.draw_circle(eye,8,contour)
		canvas.draw_circle(eye,6,led)
		canvas.draw_circle(eye+Vector2(-1.5,-1.5),2,white)
	# Antennae.
	for side in [-1,1]:
		var root:=Vector2(side*9,-24)
		var tip:=root+Vector2(side*7,-9)
		canvas.draw_line(root,tip,contour,3,true)
		canvas.draw_circle(tip,2.4,contour)
	# Thief domino mask across the eye line.
	canvas.draw_colored_polygon(PackedVector2Array([Vector2(-18,-20),Vector2(18,-20),Vector2(14,-10),Vector2(-14,-10)]),mask)
	# Red pixel-tiled dome shell; splits open during pickup to let the block settle on the back.
	var gap:=clampf(shell_open,0,1)*11.0
	for side in [-1,1]:
		var offset:=Vector2(side*gap*.5,0)
		var half:=PackedVector2Array([Vector2(side*1,-2)+offset,Vector2(side*26,4)+offset,Vector2(side*20,22)+offset,Vector2(side*1,26)+offset])
		canvas.draw_colored_polygon(half,shell.darkened(.28))
		var inset:=PackedVector2Array()
		for p in half: inset.append(p.lerp(Vector2(side*4,10)+offset,.14))
		canvas.draw_colored_polygon(inset,shell)
		canvas.draw_polyline(half,contour,3,true)
		canvas.draw_line(half[0],half[3],contour,3,true)
		# Pixel-tile texture on the dome.
		for row in 3:
			for col in 2:
				var tile_point:=Vector2(side*(6+col*8),-2+row*9)+offset
				canvas.draw_rect(Rect2(tile_point,Vector2(6,7)),shell.lightened(.12 if (row+col)%2==0 else -0.06))
				canvas.draw_rect(Rect2(tile_point,Vector2(6,7)),Color.TRANSPARENT)
	if gap<1.0:
		canvas.draw_line(Vector2(0,-2),Vector2(0,26),contour,2,true)
	# Black spots, thickly outlined, for silhouette readability at small sizes.
	for spot in [Vector2(-12,10),Vector2(12,10),Vector2(-7,20),Vector2(7,20)]:
		var side_shift:float=(1.0 if spot.x>0 else -1.0)*gap*.5
		var spot_at:Vector2=spot+Vector2(side_shift,0)
		canvas.draw_circle(spot_at,3.2,mask)
	canvas.draw_set_transform(Vector2.ZERO)

static func _oval(center: Vector2, rx: float, ry: float, points: int=20) -> PackedVector2Array:
	var array:=PackedVector2Array()
	for i in points:
		var t:=TAU*float(i)/points
		array.append(center+Vector2(cos(t)*rx,sin(t)*ry))
	return array
