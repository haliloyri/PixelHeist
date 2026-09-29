extends SceneTree
## Re-author queues against the actual nearest-target, shared-dock flight simulation.
## Run after build_content.py when the board or collection rules change.
## Level 3 mixes sealed future colours into a verified, solvable route.
const MainScene=preload("res://scenes/main.tscn")
func _initialize()->void:call_deferred("run")
func run()->void:
	var levels:Array=JSON.parse_string(FileAccess.get_file_as_string("res://data/levels.json"))
	var game=MainScene.instantiate()
	game.test_mode=true
	root.add_child(game)
	await process_frame
	game.set_process(false)
	game.speed=3
	var first_index:=0
	var only:Array=[]
	for arg in OS.get_cmdline_user_args():
		if arg.begins_with("--from-level="): first_index=int(arg.get_slice("=",1))
		if arg.begins_with("--only="):
			for part in arg.get_slice("=",1).split(","): only.append(int(part))
	var checker=MainScene.instantiate()
	checker.test_mode=true
	root.add_child(checker)
	await process_frame
	checker.set_process(false)
	# --story-overrides authors data/story_overrides.json boards in place of the
	# demo boards they replace, then writes only that file.
	var story_mode:=OS.get_cmdline_user_args().has("--story-overrides")
	var overrides:Array=[]
	if story_mode:
		overrides=JSON.parse_string(FileAccess.get_file_as_string("res://data/story_overrides.json"))
		for board in overrides:
			for i in levels.size():
				if levels[i].art_id!=board.art_id: continue
				for field in ["width","height","palette","cells","queue_seconds"]: levels[i][field]=board[field]
				game.all_levels[i]=levels[i].duplicate(true)
				checker.all_levels[i]=levels[i].duplicate(true)
				only.append(i)
	for index in range(first_index,levels.size()):
		if not only.is_empty() and not only.has(index): continue
		var attempt:=0
		var accepted:=false
		var lanes:Array=[]
		var solution:Array=[]
		var packets:=0
		var anticipation_count:=0
		while not accepted:
			if attempt>=40:
				printerr("Queue authoring failed: no overlap-safe route for level ",index+1)
				quit(1)
				return
			game.levels[index]=game.all_levels[index].duplicate(true)
			game.levels[index].queue_seconds=0
			game.levels[index].palette=game.levels[index].palette.duplicate()
			# Every palette colour absent from the painting is a decoy colour (2026-09-26: several, not only pink).
			var decoy_colours:Array=[]
			for palette_index in game.levels[index].palette.size():
				if not game.levels[index].cells.has(float(palette_index)) and not game.levels[index].cells.has(palette_index): decoy_colours.append(palette_index)
			if decoy_colours.is_empty(): decoy_colours.append(game.levels[index].palette.size()-1)
			var placeholder:int=game.levels[index].palette.size()
			game.levels[index].palette.append("#76808c")
			game._start_level(index,false)
			game.speed=3
			game.boost_remaining=100000.0
			game.auto_boost_enabled=false
			var count:int=game.puzzle.slot_count
			lanes=[]
			for col in count:lanes.append([])
			solution=[]
			var rng:=RandomNumberGenerator.new()
			rng.seed=98171+index+attempt*7919
			packets=0
			anticipation_count=0
			var next_anticipation:=0
			while game.puzzle.remaining>0:
				var counts:Dictionary={}
				for cell in game.puzzle.accessible_cells():
					var color:int=game.puzzle.board[int(cell)]
					counts[color]=int(counts.get(color,0))+1
				var color: int=-1
				var most:=0
				for candidate in counts:
					if int(counts[candidate])>most:
						color=int(candidate)
						most=int(counts[candidate])
				assert(color>=0)
				var hidden:=false
				var budget:Dictionary={}
				for cell_color in game.puzzle.board:
					if int(cell_color)>=0:budget[int(cell_color)]=int(budget.get(int(cell_color),0))+1
				var waiting:=0
				for carrier in game.puzzle.active:
					if carrier.is_empty():continue
					waiting+=1
					budget[int(carrier.color)]=int(budget.get(int(carrier.color),0))-int(carrier.left)
				if index>=10 and packets>=next_anticipation and waiting<2:
					var candidate:=nearby_sealed_colour(game.puzzle,counts,budget)
					if candidate>=0:
						color=candidate
						hidden=true
						anticipation_count+=1
						next_anticipation=packets+rng.randi_range(5,8)
				if index>=10 and not hidden and packets%3==2:
					# Clearing a smaller exposed patch can leave its deeper colour sealed again.
					for candidate in counts:
						if int(counts[candidate])<most:
							color=int(candidate)
							most=int(counts[candidate])
				var column:=packets%3 if index<2 else rng.randi_range(0,count-1)
				var amount:=mini(most,rng.randi_range(3,7) if index>=5 else rng.randi_range(5,9))
				if hidden:amount=mini(int(budget[color]),rng.randi_range(2,4))
				else:amount=mini(amount,int(budget.get(color,0)))
				assert(amount>0 and game.puzzle.free_slot()>=0,"Author must retain room for an opening colour")
				var packet:={"color":color,"amount":amount}
				if hidden:packet["anticipation"]=true
				if index>=5 and packets%5==1:
					lanes[column].append({"color":decoy_colours[rng.randi_range(0,decoy_colours.size()-1)],"amount":rng.randi_range(3,5),"decoy":true})
					solution.append(-column-1)
				lanes[column].append(packet)
				solution.append(column)
				# An unavailable placeholder prevents a false "no remaining capsules" result
				# while this offline author creates the next packet. It is never exported.
				game.puzzle.lanes=[]
				for col in count:game.puzzle.lanes.append([{"color":placeholder,"amount":1}])
				game.puzzle.lanes[column]=[packet.duplicate()]
				var destination:int=game.puzzle.deployment_slot(column)
				game._deploy(column)
				var ticks:=0
				while game.busy and ticks<2000:
					game._process(.25)
					ticks+=1
				if game.busy or game.modal_kind in ["blocked","error"] or (not hidden and not game.puzzle.active[destination].is_empty()):
					break
				game._close_modal()
				packets+=1
			for column in count:
				for depth in lanes[column].size():
					if depth>0 and (depth+column)%4==1: lanes[column][depth]["mystery"]=true
			levels[index].lanes=lanes
			levels[index].solution=solution
			attempt+=1
			if game.puzzle.remaining>0:
				game._close_modal()
				continue
			var candidate:Dictionary=levels[index].duplicate(true)
			candidate.lanes=lanes
			candidate.solution=solution
			var failure:=overlap_failure(checker,candidate)
			if failure.is_empty(): accepted=true
			else: print("RETRY ",index+1," attempt ",attempt,": ",failure)
		print("AUTHORED ",index+1," ",levels[index].title," | ",packets," packets | ",anticipation_count," sealed-colour choices | attempt ",attempt)
		await process_frame
	if story_mode:
		for board in overrides:
			for level in levels:
				if level.art_id==board.art_id:
					board.lanes=level.lanes
					board.solution=level.solution
		var story_file:=FileAccess.open("res://data/story_overrides.json",FileAccess.WRITE)
		story_file.store_string(JSON.stringify(overrides," ",false)+"\n")
		story_file.close()
	else:
		var file:=FileAccess.open("res://data/levels.json",FileAccess.WRITE)
		file.store_string(JSON.stringify(levels,"  ",false)+"\n")
		file.close()
	game.queue_free()
	checker.queue_free()
	await process_frame
	quit()

func nearby_sealed_colour(puzzle,exposed:Dictionary,budget:Dictionary)->int:
	# Prefer colours a few layers behind the present frontier, not distant endgame pixels.
	var distances:=PackedInt32Array()
	distances.resize(puzzle.board.size())
	distances.fill(-1)
	var queue:Array=puzzle.accessible_cells().duplicate()
	for cell in queue:distances[int(cell)]=0
	var active_colours:Dictionary={}
	for carrier in puzzle.active:
		if not carrier.is_empty():active_colours[int(carrier.color)]=true
	var head:=0
	while head<queue.size():
		var cell:int=queue[head]
		head+=1
		var color:int=puzzle.board[cell]
		if color>=0 and not exposed.has(color) and not active_colours.has(color) and int(budget.get(color,0))>0:return color
		if distances[cell]>=5:continue
		var point:=Vector2i(cell%puzzle.width,cell/puzzle.width)
		for direction in [Vector2i.UP,Vector2i.LEFT,Vector2i.RIGHT,Vector2i.DOWN]:
			var next:Vector2i=point+direction
			if next.x<0 or next.x>=puzzle.width or next.y<0 or next.y>=puzzle.height:continue
			var next_cell:int=next.y*puzzle.width+next.x
			if distances[next_cell]>=0:continue
			distances[next_cell]=distances[cell]+1
			queue.append(next_cell)
	return -1

## A real player does not wait for every flight to land. The authored order must
## win when each move is made as soon as a dock is free, after short and longer
## pauses, with and without automatic 3×. Negative steps let unwanted packets
## expire on their own (P08-I05).
func overlap_failure(checker,level:Dictionary)->String:
	checker.all_levels=checker.all_levels.duplicate(true)
	var index:int=-1
	for i in checker.all_levels.size():
		if checker.all_levels[i].art_id==level.art_id: index=i
	checker.all_levels[index]=level.duplicate(true)
	for think in [0.0,1.0,2.0,4.0]:
		for boost in [false,true]:
			var result:=play(checker,index,think,boost)
			if result!="won": return "%s at think=%.1f boost=%s" % [result,think,boost]
	return ""

static func play(game,index:int,think:float,boost:bool)->String:
	const DT:=0.1
	game.levels=game.all_levels.duplicate(true)
	game.boost_remaining=100000.0 if boost else 0.0
	game.auto_boost_enabled=boost
	game.speed=1
	game._start_level(index,false)
	var solution:Array=game.current_level().solution
	var initial:Array=game.puzzle.lanes.map(func(lane):return lane.size())
	var expected:Array=[]
	expected.resize(initial.size());expected.fill(0)
	var step:=0
	var cooldown:=think
	var elapsed:=0.0
	while elapsed<1800.0:
		if not game.modal_kind.is_empty(): break
		if step<solution.size():
			var value:=int(solution[step])
			var lane:=value if value>=0 else -value-1
			var consumed:int=initial[lane]-game.puzzle.lanes[lane].size()
			if value<0:
				if consumed>expected[lane]:
					expected[lane]+=1;step+=1;cooldown=think
					continue
			else:
				cooldown-=DT
				if cooldown<=0.0 and consumed==expected[lane] and game.puzzle.can_deploy(value):
					game._deploy(value);expected[lane]+=1;step+=1;cooldown=think
		game._process(DT)
		elapsed+=DT
	if game.modal_kind=="result" and game.puzzle.status()=="won": return "won"
	return game.modal_kind if not game.modal_kind.is_empty() else "timeout"
