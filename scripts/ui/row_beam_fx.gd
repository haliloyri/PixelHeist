extends RefCounted
## Cosmetic transfer only. Logical removal/stock commit happens once in the controller.
const HOLD := .16
const TRAVEL := 1.12
const REDUCED_DURATION := .45
static func lifetime(effect: Dictionary) -> float:
	return REDUCED_DURATION if effect.reduced else float(effect.delay)+HOLD+TRAVEL

static func pose(effect: Dictionary, start: Vector2, target: Vector2) -> Dictionary:
	var age := float(effect.age)
	if effect.reduced:
		return {"position":start,"alpha":1.0-smoothstep(.08,REDUCED_DURATION,age),"scale":1.0,"travel":0.0,"flash":1.0-smoothstep(0,.18,age)}
	var t := clampf((age-float(effect.delay)-HOLD)/TRAVEL,0,1)
	# Disappear on the way, before reaching the dock: no second delivery is implied.
	var u := smoothstep(0,1,t)*.86
	var bend := Vector2(lerpf(start.x,target.x,.45)+sin(float(effect.cell)*1.7)*24,lerpf(start.y,target.y,.40))
	var point := start.lerp(bend,u).lerp(bend.lerp(target,u),u)
	return {"position":point,"alpha":1.0-smoothstep(.48,1,t),"scale":lerpf(1,.08,smoothstep(.35,1,t)),"travel":t,"flash":1.0-smoothstep(.02,HOLD,age)}
