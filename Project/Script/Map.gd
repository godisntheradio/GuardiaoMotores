extends Spatial
class_name Map
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var TileClass = preload("res://Objects/Tile.tscn")
export var mapTiles = []
export var width : int # cresce para x+ 
export var height : int # cresce para z+
export var starting_camera_position : Vector3

var mlgm : MultiLayerGridMap = null

class Sorter:
	static func sort(a, b):
		if(a.translation.x < b.translation.x):
			return true
		elif(a.translation.x > b.translation.x):
			return false
		elif(a.translation.z < b.translation.z):
			return true
		elif(a.translation.z > b.translation.z):
			return false
		

# Called when the node enters the scene tree for the first time.
func _ready():
	mlgm = get_node("MultiLayer GridMap")
	
	var cells = mlgm.gridmaps[0].get_used_cells()
	var minPos : Vector2 = Vector2(1e+100, 1e+100)
	for c in cells:
		if(c.x < minPos.x):
			minPos.x = c.x
		if(c.z < minPos.y):
			minPos.y = c.z	
	global_transform.origin = mlgm.map_to_world(Vector3(minPos.x, 0, minPos.y))
	
	for c in cells:
		var tileProps = mlgm.get_tile(c)
		var tileInst = TileClass.instance()
		mapTiles.append(tileInst)
		add_child(tileInst)
		tileInst.translation = mlgm.cell_size / 2 + mlgm.cell_size * (c - Vector3(minPos.x, 0, minPos.y))
		if(tileProps["blocked"] != null):
			tileInst.blocked = tileProps["blocked"]
		if(tileProps["initial_pos"] != null):
			tileInst.starting_position = tileProps["initial_pos"]
	
	mapTiles.sort_custom(Sorter, "sort")
	var last_pos = world_to_map(mapTiles.back().global_transform.origin)
	width = last_pos.x + 1
	height = last_pos.y + 1
	
	
	CameraManager.relocate(starting_camera_position)
	

func world_to_map(p : Vector3):
	p -= translation
	var tSize = mapTiles[0].get_node("MeshInstance").mesh.size.x
	return Vector2(floor(p.x / tSize), floor(p.z / tSize))

func get_tile(pos : Vector2):
	return mapTiles[pos.y * width + pos.x]