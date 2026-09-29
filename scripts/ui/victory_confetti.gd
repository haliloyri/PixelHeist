extends Control
## One bounded, deterministic burst. Rendering never changes gameplay RNG or rewards.
const COLORS=[Color("ffe5a0"),Color("38dbc3"),Color("ef859e"),Color("76b9ee"),Color("c9a0ef")]
const DURATION=3.2
var age:=0.0
var pieces:Array=[]
func setup(reduced_motion:bool)->void:
	mouse_filter=Control.MOUSE_FILTER_IGNORE
	clip_contents=true
	if reduced_motion:return
	var rng:=RandomNumberGenerator.new();rng.seed=5716
	for i in 84:
		var left:=i%2==0
		pieces.append({"origin":Vector2(24 if left else 640,380),"velocity":Vector2(rng.randf_range(75,270)*(1 if left else -1),rng.randf_range(-500,-235)),"delay":rng.randf_range(0,.18),"spin":rng.randf_range(-7,7),"phase":rng.randf_range(0,TAU),"color":COLORS[i%COLORS.size()],"width":rng.randf_range(5,10),"length":rng.randf_range(10,19)})
func sample(time:float)->void:
	age=time
	queue_redraw()
func visible_piece_count()->int:
	return pieces.size() if age<DURATION else 0
func _draw()->void:
	if age>=DURATION:return
	for piece in pieces:
		var t:=age-float(piece.delay)
		if t<0:continue
		var position:Vector2=piece.origin+piece.velocity*t+Vector2(0,165*t*t)
		var color:Color=piece.color
		color.a=clampf((DURATION-age)/.65,0,1)
		draw_set_transform(position,float(piece.phase)+t*float(piece.spin))
		var width:float=maxf(2,absf(cos(t*6+float(piece.phase)))*float(piece.width))
		draw_rect(Rect2(-width*.5,-float(piece.length)*.5,width,float(piece.length)),color)
	draw_set_transform(Vector2.ZERO)
