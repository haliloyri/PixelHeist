extends RefCounted
## Shared geometry for queue hit targets, carriers and flight origins.
## 2026-09-25 (9:16 pass): 720x1280 design space; board, carriers, queue and ants follow
## the proportions of Halil's reference screenshot (tight dock row, compact queue grid).
## Dock spacing never drops below the 88-unit (~44 pt) tap target.
const DOCK_Y := 752.0
const FRONT_Y := 883.0
const ROW_GAP := 90.0
static func spacing(count:int)->float:
	return minf(132.0, 650.0 / float(count))
static func dock(slot:int,count:int)->Vector2:
	return Vector2(360.0+(slot-(count-1)*.5)*spacing(count),DOCK_Y)
static func front(column:int,count:int)->Rect2:
	var extent:=Vector2(112,86)
	return Rect2(Vector2(360.0 + (column % 3 - 1)*148.0-extent.x*.5,FRONT_Y-extent.y*.5),extent)
## Centre of a queue packet: depth 0 is the tappable front row.
static func row(column:int,count:int,depth:int)->Vector2:
	return Vector2(360.0 + (column % 3 - 1)*148.0,FRONT_Y+depth*ROW_GAP+(36 if depth >= 3 else 0))
static func carrier_radius(count:int)->float:
	return spacing(count)*.5

## ---- Docked cube geometry on screen (2026-09-26 door walk) --------------------------
## depth_heist.gd draws a docked carrier as a camera-facing cube sprite, 1.5 world units
## wide at DOCK_SCALE, lifted CUBE_LIFT above the floor; the orthographic camera is tilted
## by DEPTH_TILT, so height h moves a point up the screen by 100*h*sin(tilt) units.
## These helpers turn that into 2D points: the door on the cube's player-facing face,
## and the lane round the cube's flank that the ants use.
const DEPTH_TILT := 0.22
const CUBE_ASPECT := 215.0/256.0
static func dock_scale(count:int)->float:
	return cube_size(count).x / 150.0
static func cube_size(count:int)->Vector2:
	var width:=minf(108.0, spacing(count)*.82)
	return Vector2(width,width*113.0/148.0)
static func cube_center(slot:int,count:int)->Vector2:
	return dock(slot,count)
## Just outside the door, where an ant appears.
static func door(slot:int,count:int)->Vector2:
	return cube_center(slot,count)+Vector2(0,cube_size(count).y*.5+4)
## Inside the doorway, where an ant has vanished into the cube.
static func door_inside(slot:int,count:int)->Vector2:
	return cube_center(slot,count)+Vector2(0,cube_size(count).y*.3)
## Centre of the glowing door frame.
static func door_glow(slot:int,count:int)->Vector2:
	return cube_center(slot,count)+Vector2(0,cube_size(count).y*.4)
## Horizontal offset of the lane beside a cube (the gap between neighbouring docks).
static func flank(count:int)->float:
	return maxf(spacing(count)*.5-1,cube_size(count).x*.5+12)
## Where the flank lane leaves the cube behind on its way to the painting.
static func flank_top(slot:int,count:int)->float:
	return cube_center(slot,count).y-cube_size(count).y*.5-6
