extends Node
## Independent low-level loops; fixed playback pitch even when game speed changes.
## Music: heist_adventure.ogg (2026-09-26, original, tools/build_music.py) replaced the
## tense "Insistent" loop with an upbeat adventure theme.
var music:AudioStreamPlayer
var motor:AudioStreamPlayer
var music_gain:=0.0
var motor_gain:=0.0

func _ready()->void:
	music=_voice("res://assets/audio/heist_adventure.ogg")
	motor=_voice("res://assets/audio/drone_motor.ogg")

func _voice(path:String)->AudioStreamPlayer:
	var player:=AudioStreamPlayer.new()
	var stream:AudioStreamOggVorbis=load(path).duplicate()
	stream.loop=true
	player.stream=stream
	player.volume_db=-80
	add_child(player)
	return player

func update_mix(delta:float,gameplay:bool,fleet_size:int,enabled:bool,music_enabled:bool,silent:bool)->void:
	if silent:
		stop_all()
		return
	var music_target:=db_to_linear(-25.0) if gameplay and enabled and music_enabled else 0.0
	var motor_target:=db_to_linear(-31.0+minf(fleet_size/36.0,1.0)*3.0) if gameplay and enabled and fleet_size>0 else 0.0
	music_gain=lerpf(music_gain,music_target,1-exp(-delta*3))
	motor_gain=lerpf(motor_gain,motor_target,1-exp(-delta*4))
	_apply(music,music_gain)
	_apply(motor,motor_gain)

func _apply(player:AudioStreamPlayer,gain:float)->void:
	if gain<.0001:
		player.stream_paused=true
		return
	if not player.playing:player.play()
	player.stream_paused=false
	player.volume_linear=gain

func stop_all()->void:
	music_gain=0
	motor_gain=0
	if is_instance_valid(music):music.stop()
	if is_instance_valid(motor):motor.stop()

func _exit_tree()->void:
	stop_all()
	if is_instance_valid(music):music.stream=null
	if is_instance_valid(motor):motor.stream=null
