extends RefCounted
## Frameless navigation objects, paired with the reward enamel palette.
const ATLAS=preload("res://assets/ui/home/enamel_navigation.png")
const CELLS={"shop":0,"home":1,"museum":2,"case_file":3}

static func attach(parent:Node,kind:String,rect:Rect2)->TextureRect:
	var cell:=ATLAS.get_width()/2
	var index:int=CELLS[kind]
	var atlas:=AtlasTexture.new()
	atlas.atlas=ATLAS;atlas.region=Rect2((index%2)*cell,(index/2)*cell,cell,cell)
	atlas.filter_clip=true
	var view:=TextureRect.new()
	view.name="Illustration";view.texture=atlas
	view.expand_mode=TextureRect.EXPAND_IGNORE_SIZE
	view.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	view.mouse_filter=Control.MOUSE_FILTER_IGNORE
	parent.add_child(view);view.position=rect.position;view.size=rect.size
	return view
