extends RefCounted
## Access derives from existing artwork completion; only Stage 1 is authored.
static var SCENES:Dictionary=JSON.parse_string(FileAccess.get_file_as_string("res://data/stage_scenes.json"))

static func stages(game)->Array:
	var result:Array=[]
	for stage in game.campaign.stages:
		var progress:int=game.campaign.stage_progress(int(stage.number),game.store.state.completed)
		var unlocked:bool=int(stage.number)==1 or progress>0
		if not unlocked:
			unlocked=game.campaign.stage_progress(int(stage.number)-1,game.store.state.completed)==10
		var panels:Array=[]
		if unlocked and SCENES.has(stage.id):
			panels.append(SCENES[stage.id].opening)
			if progress==10:panels.append(SCENES[stage.id].finale)
		result.append({"stage":stage,"unlocked":unlocked,"completed":progress==10,"progress":progress,"scenes":panels})
	return result
