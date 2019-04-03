extends Spatial
class_name Map
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var TileClass = preload("res://Objects/Tile.tscn")
export var mapTiles = []
export var width : int # cresce para x+ 
export var height : int # cresce para z+
export var procedural : bool
# Called when the node enters the scene tree for the first time.
func _ready():
	if (procedural):
		for y in range(height):
			for x in range(width):
				var instance = TileClass.instance()
				var mesh = instance.get_node("MeshInstance").mesh
				add_child(instance)
				instance.translate(Vector3(translation.x + mesh.size.x * x, 0 , translation.z + mesh.size.z * y ))
				mapTiles.append(instance)
				instance.name = instance.name + str(x) + str(y)
	else:# get tiles from pre
		var tiles = get_children()
		for t in tiles:
			mapTiles.append(t)

func world_to_map(p : Vector3):
	p -= translation
	var tSize = mapTiles[0].get_node("MeshInstance").mesh.size.x
	return Vector2(floor(p.x / tSize), floor(p.z / tSize))

func get_tile(pos : Vector2):
	return mapTiles[pos.y * width + pos.x]