extends TextureRect
const ATLAS=preload("res://assets/ui/crew/portraits.png")
const IDS=["bit","dash","gizmo","hum","flicker","pinch","skitter","velvet","tock","nova"]
func setup(id:String,unlocked:bool)->void:
	var index:int=IDS.find(id)
	if index<0:return
	var extent:=Vector2(ATLAS.get_width()/5.0,ATLAS.get_height()/2.0)
	var region:=AtlasTexture.new();region.atlas=ATLAS
	region.region=Rect2(Vector2(index%5,index/5)*extent,extent)
	region.filter_clip=true
	texture=region
	expand_mode=TextureRect.EXPAND_IGNORE_SIZE
	stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	mouse_filter=Control.MOUSE_FILTER_IGNORE
	if not unlocked:modulate=Color(.45,.50,.53,.70)
