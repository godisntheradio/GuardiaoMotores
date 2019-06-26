extends Spatial
class_name Map
var TileClass = preload("res://Objects/Tile.tscn")
var mapTiles
export var width : int # cresce para x+ 
export var height : int # cresce para z+
export var starting_camera_position : Vector3

var mlgm : MultiLayerGridMap = null

class Sorter:
	static func sort(a, b):
		if(a.translation.z < b.translation.z):
			return true
		elif(a.translation.z > b.translation.z):
			return false
		elif(a.translation.x < b.translation.x):
			return true
		elif(a.translation.x > b.translation.x):
			return false

func _ready():
	mapTiles = []
	mlgm = get_node("MultiLayer GridMap")
	if mlgm:
		var cells = mlgm.gridmaps[0].get_used_cells()
		var minPos : Vector2 = Vector2(1e+100, 1e+100)
		for c in cells:
			if(c.x < minPos.x):
				minPos.x = c.x
			if(c.z < minPos.y):
				minPos.y = c.z
		global_transform.origin = mlgm.to_global(mlgm.map_to_world(Vector3(minPos.x, 0, minPos.y))) - mlgm.cell_size / 2
		
		for c in cells:
			var tileProps = mlgm.get_tile(c)
			var idx = mlgm.gridmaps[0].get_cell_item(c.x,c.y,c.z)
			var mesh =  mlgm.gridmaps[0].mesh_library.get_item_mesh(idx)
			var mat = mesh.surface_get_material(0).duplicate()
			var tileInst = TileClass.instance()
			tileInst.get_node("MeshInstance").set_surface_material(0,mat)
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
		print(str(minPos))
		print(global_transform.origin)
		mlgm.queue_free()
	else:
		for c in get_children():
			mapTiles.append(c)
	CameraManager.relocate(starting_camera_position)
	

func world_to_map(p : Vector3):
	p -= translation
	var tSize = mapTiles[0].get_node("MeshInstance").mesh.size.x
	return Vector2(floor(p.x / tSize), floor(p.z / tSize))

func get_tile(pos : Vector2):
	return mapTiles[(pos.y * width + pos.x)]