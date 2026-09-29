extends RefCounted
## One semantic atlas for Safehouse shortcuts, reward cards and receipts.
const ATLAS=preload("res://assets/ui/rewards/enamel_objects.png")
const CELLS={"daily":0,"stars":1,"chapter":2,"coins":3,"no_ads":4,"offer":5}

static func texture(kind:String)->AtlasTexture:
	var index:int=CELLS.get(kind,0)
	var result:=AtlasTexture.new()
	result.atlas=ATLAS
	result.region=Rect2((index%3)*512,(index/3)*512,512,512)
	result.filter_clip=true
	return result

static func attach(parent:Node,kind:String,rect:Rect2)->TextureRect:
	var view:=TextureRect.new()
	view.name="Illustration";view.texture=texture(kind)
	view.expand_mode=TextureRect.EXPAND_IGNORE_SIZE
	view.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	view.mouse_filter=Control.MOUSE_FILTER_IGNORE
	parent.add_child(view);view.position=rect.position;view.size=rect.size
	return view
