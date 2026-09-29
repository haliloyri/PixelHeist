extends "res://scripts/ui/victory_confetti.gd"
## Cosmetic receipt celebration; the reward is already committed before this exists.
var game
var chest:Control
var reduced:=false
func start(controller,chest_view:Control)->void:
	game=controller;chest=chest_view;reduced=game.reduced_motion
	chest.pivot_offset=chest.size*.5
	setup(reduced)
	if not reduced:
		pieces.resize(56)
		for piece in pieces:
			piece.origin=Vector2(24 if piece.origin.x<100 else size.x-24,92)
			piece.velocity*=.55
	else:sample(DURATION)
	set_process(not reduced)
func _process(delta:float)->void:
	if game.app_suspended or game.modal_kind!="reward":return
	advance(delta)
func advance(delta:float)->void:
	if reduced:return
	sample(minf(DURATION,age+maxf(delta,0)))
	var pulse:=sin(clampf(age/.65,0,1)*PI)*.12 if age<.65 else 0.0
	chest.scale=Vector2.ONE*(1+pulse)
	if age>=DURATION:set_process(false)
