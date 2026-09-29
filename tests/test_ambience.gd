extends SceneTree
const Ambience=preload("res://scripts/core/ambience.gd")
var failures:=0
var checks:=0
func check(ok:bool,label:String)->void:
	checks+=1
	if not ok:
		failures+=1
		printerr("FAIL: ",label)
func _initialize()->void:call_deferred("run")
func run()->void:
	var mix=Ambience.new()
	root.add_child(mix)
	check(mix.music.stream.loop and mix.motor.stream.loop,"Both audio layers loop")
	check(mix.music.stream.get_length()>100 and mix.motor.stream.get_length()>4,"Downloaded and prepared audio assets decode")
	for frame in 180:mix.update_mix(1.0/60,true,12,true,true,false)
	check(mix.music.playing and mix.motor.playing,"Gameplay enables the music and active rotor layer")
	check(mix.music.volume_db< -24 and mix.motor.volume_db< -28,"Background levels stay below foreground contacts")
	check(mix.music.pitch_scale==1 and mix.motor.pitch_scale==1,"Audio layers keep their original pitch")
	for frame in 300:mix.update_mix(1.0/60,true,0,true,false,false)
	check(mix.music.stream_paused and mix.motor.stream_paused,"Music toggle and inactive fleet silence their own layers")
	for frame in 180:mix.update_mix(1.0/60,true,24,true,true,false)
	for frame in 300:mix.update_mix(1.0/60,false,24,true,true,false)
	check(mix.music.stream_paused and mix.motor.stream_paused,"Pause and menus fade background layers out")
	mix.stop_all()
	check(not mix.music.playing and not mix.motor.playing,"Master mute stops both loops immediately")
	mix.queue_free()
	await create_timer(.1).timeout
	print("AUDIO CHECKS: ",checks," | FAILURES: ",failures)
	quit(0 if failures==0 else 1)
