extends Control
## Scouts are robot ants (assets/ants, tinted by ant_skin.gd) drawn in 2D on top of the
## 3D board. They carry the picked pixel at its exact on-board size and a pickup throws
## a small puff of dust plus flying sparks in the pixel's colour.
const Drone=preload("res://scripts/ui/drone_design.gd")
const Gait = preload("res://scripts/ui/ant_gait.gd")
const AntSkin=preload("res://scripts/ui/ant_skin.gd")
const QueueLayout=preload("res://scripts/ui/queue_layout.gd")
## 2026-09-26: ants use the door on the cube's player-facing face. They fade in/out over
## the last DOOR_FADE units inside the doorway, and the door glows while ants pass it.
const DOOR_FADE := 11.0
const DOOR_GLOW_REACH := 46.0
## Ant body length relative to one board tile, clamped to the reference sizes.
## 2026-09-25 (9:16 pass): ~26 units long, as in the reference screenshot.
const ANT_TILES := 2.9
const ANT_MIN := 27.0
const ANT_MAX := 38.0
const ANT_WIDTH_SCALE := .86
const EFFECT_TIME := .55
var game: Control
func _ready() -> void:mouse_filter=Control.MOUSE_FILTER_IGNORE

func clear_radius(point:Vector2,maximum:float)->float:
	# Large silhouettes outside; fit the actual empty corridor inside the artwork.
	var area:Rect2=game.board_art.art_rect()
	area.position+=game.board_art.position
	var tile:float=area.size.x/game.puzzle.width
	var cell:=Vector2i((point-area.position)/tile)
	var reach:=ceili(maximum/tile)+1
	var radius:=maximum
	for y in range(maxi(0,cell.y-reach),mini(game.puzzle.height,cell.y+reach+1)):
		for x in range(maxi(0,cell.x-reach),mini(game.puzzle.width,cell.x+reach+1)):
			if int(game.puzzle.board[y*game.puzzle.width+x])<0:continue
			var corner:=area.position+Vector2(x,y)*tile
			var nearest:=point.clamp(corner,corner+Vector2.ONE*tile)
			radius=minf(radius,maxf(1,point.distance_to(nearest)-.5))
	return radius

static func ant_length(tile: float) -> float:
	return clampf(tile*ANT_TILES,ANT_MIN,ANT_MAX)

func cube(point:Vector2,side:float,tint:Color)->void:
	var rect:=Rect2(point-Vector2.ONE*side*.5,Vector2.ONE*side)
	draw_rect(rect.grow(.8),tint.darkened(.5))
	draw_rect(rect,tint)
	draw_rect(Rect2(rect.position,Vector2(side,maxf(1,side*.18))),tint.lightened(.4))
	draw_rect(Rect2(rect.position+Vector2(0,side*.78),Vector2(side,side*.22)),tint.darkened(.3))
	draw_line(rect.position,rect.position+Vector2(0,side),tint.lightened(.18),1)

func ant(point:Vector2,length:float,heading:float,tint:Color,phase:float,alpha:float=1.0)->void:
	var texture:=AntSkin.texture(tint)
	var width:=length*float(texture.get_width())/float(texture.get_height())
	# Alternating planted feet; no altitude bob, wings or hovering shadow.
	draw_set_transform(point,heading+PI/2,Vector2(ANT_WIDTH_SCALE,1))
	for side in [-1,1]:
		for leg in 3:
			var joints := Gait.leg(side,leg,phase,length)
			draw_polyline(joints,Color(tint.darkened(.75),alpha),maxf(2,length*.075),true)
			draw_polyline(joints,Color(tint.lightened(.25),alpha),maxf(1,length*.037),true)
			draw_circle(joints[1],maxf(1,length*.045),Color(tint.lightened(.42),alpha))
			draw_circle(joints[2],maxf(.8,length*.035),Color(tint.darkened(.3),alpha))
	# Sprite's head is at -Y. Heading follows the ground route in both directions.
	draw_texture_rect_region(texture,Rect2(-width*.28,-length*.5,width*.56,length),Rect2(texture.get_width()*.22,0,texture.get_width()*.56,texture.get_height()),Color(1,1,1,alpha))
	draw_set_transform(Vector2.ZERO)

func _draw() -> void:
	if not is_instance_valid(game) or game.screen!="play":return
	if not is_instance_valid(game.board_art):return
	var palette:Array=game.current_level().palette
	_door_glows(palette)
	for drone in game.flights:
		var point:Vector2=drone.position
		var tint:=Color(palette[int(drone.color)])
		var tile:=float(drone.tile_size)
		var length:=ant_length(tile)
		var carrying:bool=int(drone.phase)==1
		var lifting:bool=carrying and float(drone.dwell)>0
		var lift:=clampf(1.0-float(drone.dwell)/game.PICKUP_LIFT_TIME,0,1)
		var forward:=Vector2.RIGHT.rotated(float(drone.heading))
		# The pixel rides over the ant's head, always at exactly one board tile: picking it up
		# never scales it (2026-09-25 feedback: "pixel must not grow when the ant takes it").
		var cargo:=point+forward*length*.24
		var cargo_side:=tile*.92
		if lifting and not game.reduced_motion:
			var target:Vector2=drone.target
			cargo=target.lerp(cargo,smoothstep(.15,1,lift))
		elif lifting:
			cargo=Vector2(drone.target).lerp(cargo,lift)
		var phase := 0.0 if game.reduced_motion else Gait.phase(float(drone.get("walk_distance",0.0)),length)
		# The first ant at a closed frame passage pecks the rail: quick forward jabs.
		if drone.get("pecking",false) and not game.reduced_motion:
			var pecked:float=float(game.gap_peck[int(drone.gap)])
			var jab:=pow(absf(sin(clampf(pecked/game.PECK_TIME,0,1)*game.PECKS*PI)),3.0)
			point+=forward*length*.2*jab
		# Fade through the doorway: invisible inside the cube, fully shown once outside.
		var fade:=clampf(point.distance_to(Vector2(drone.origin))/DOOR_FADE,0,1)
		if fade<=.02:continue
		ant(point,length,float(drone.heading),tint,phase,fade)
		if carrying:
			var cargo_tint := preload("res://scripts/ui/artwork_pixels.gd").color_at(game.current_level(),int(drone.cell))
			cube(cargo,cargo_side,Color(cargo_tint,fade) if fade<1 else cargo_tint)
	for departure in game.departures:
		if is_instance_valid(game.depth_view):break
		var pose:=Drone.departure_pose(departure,game.DEPARTURE_TIME)
		var tint:=Color(palette[int(departure.color)])
		Drone.paint(self,pose.position,float(pose.radius),tint,float(pose.heading),0,1,float(Time.get_ticks_msec())*.025)
	for effect in game.pickup_effects:_pickup_effect(effect,palette)

## Pickup burst: a grey dust puff plus tiny sparks in the pixel's colour. Directions are
## seeded from the scout id so the burst is stable across redraws.
func _pickup_effect(effect:Dictionary,palette:Array)->void:
	var t:float=clampf(float(effect.age)/EFFECT_TIME,0,1)
	var at:Vector2=effect.position
	var color:=Color(palette[int(effect.color)])
	if effect.has("cell"): color=preload("res://scripts/ui/artwork_pixels.gd").color_at(game.current_level(),int(effect.cell))
	var tile:=float(effect.get("tile",10.0))
	if game.reduced_motion:
		var ring:=color.lightened(.3);ring.a=(1-t)*.6
		draw_arc(at,tile*.5+t*tile*.6,0,TAU,18,ring,1.5,true)
		return
	var rng:=RandomNumberGenerator.new()
	rng.seed=int(effect.get("seed",0))*7919+17
	var grow:=1.0-pow(1.0-t,3)
	# Dust puff: soft grey blobs drifting outward and upward while fading.
	for i in 6:
		var angle:=rng.randf_range(0,TAU)
		var reach:=rng.randf_range(.5,1.1)*tile*1.6
		var p:=at+Vector2.RIGHT.rotated(angle)*reach*grow+Vector2(0,-tile*.8*grow)
		var r:=tile*rng.randf_range(.35,.6)*(.6+grow*.9)
		draw_circle(p,r,Color(.86,.84,.8,.34*(1-t)))
	# Sparks: small squares in the pixel colour, with a light core.
	for i in 9:
		var angle:=rng.randf_range(0,TAU)
		var speed:=rng.randf_range(1.4,2.8)*tile
		var p:=at+Vector2.RIGHT.rotated(angle)*speed*grow+Vector2(0,tile*1.2*t*t)
		var s:=maxf(1.5,tile*rng.randf_range(.18,.3)*(1-t*.6))
		var c:=color.lightened(rng.randf_range(.1,.45));c.a=1-t
		draw_rect(Rect2(p-Vector2.ONE*s*.5,Vector2.ONE*s),c)
	var flash:=Color(1,1,.92,.55*(1-smoothstep(0,.4,t)))
	draw_circle(at,tile*(.4+t*.5),flash)

## Door light on each docked cube while its ants come out (or go back in).
func _door_glows(palette:Array)->void:
	var count:int=game.puzzle.dock_count()
	var glow:={}
	for drone in game.flights:
		var slot:=int(drone.slot)
		var door: Vector2 = QueueLayout.door(slot,count)+game.heist_offset()
		var near:=maxf(.35,1.0-clampf(Vector2(drone.position).distance_to(door)/DOOR_GLOW_REACH,0,1))
		# Leaving ants light the door a little longer (their first legs round the cube).
		if int(drone.phase)==0 and int(drone.segment)<=3:near=maxf(near,.75)
		glow[slot]=maxf(float(glow.get(slot,0.0)),near)
	for slot in glow:
		var amount:float=glow[slot]
		if amount<=.01 or slot>=count or game.puzzle.active[slot].is_empty():continue
		var tint:=Color(palette[int(game.puzzle.active[slot].color)])
		var light:=tint.lightened(.62)
		var cube:=QueueLayout.cube_size(count)
		var center: Vector2 = QueueLayout.door_glow(slot,count)+game.heist_offset()
		var door:=Vector2(cube.x*.17,cube.y*.2)
		# Soft halo, a light spill on the floor, then the lit doorway itself.
		for k in 3:
			draw_set_transform(center,0,Vector2(1,.78))
			draw_circle(Vector2.ZERO,door.x*(.9+k*.55),Color(light,.17*amount/float(k+1)))
		draw_set_transform(center+Vector2(0,door.y*.5+3),0,Vector2(1,.28))
		draw_circle(Vector2.ZERO,door.x*1.5,Color(light,.28*amount))
		draw_set_transform(Vector2.ZERO)
		draw_rect(Rect2(center-door*.5,door),Color(1,1,.95,.5*amount))
		draw_rect(Rect2(center-door*.5,door).grow(-1.5),Color(light,.55*amount))
