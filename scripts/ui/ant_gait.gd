extends RefCounted
## Tripod gait driven by route distance, never wall-clock time.
static func phase(distance: float, length: float) -> float:
	return TAU*distance/maxf(1,length*1.25)

static func leg(side: int, index: int, phase_: float, length: float) -> PackedVector2Array:
	var cycle := fposmod(phase_/TAU+(.5 if (index+int(side>0))%2 else 0),1.0)
	# Planted foot moves backward against body travel; recovery swings it forward.
	var planted := cycle < .62
	var progress := cycle/.62 if planted else (cycle-.62)/.38
	var stride := lerpf(-.17,.17,progress) if planted else lerpf(.17,-.17,smoothstep(0,1,progress))
	var spread: float = .28+(0.0 if planted else sin(progress*PI)*.10)
	var root := Vector2(side*.10,-.13+index*.15)*length
	var knee := Vector2(side*.23,root.y/length+stride*.5-.035)*length
	var foot := Vector2(side*spread,root.y/length+stride)*length
	return PackedVector2Array([root,knee,foot])
