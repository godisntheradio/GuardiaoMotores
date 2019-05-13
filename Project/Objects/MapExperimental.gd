extends Spatial
class_name MapExperimental
var TileClass = preload("res://Objects/Tile.tscn")
export var mapTiles = []
export var width : int # cresce para x+ 
export var height : int # cresce para z+
export var procedural : bool
export var starting_camera_position : Vector3
var mlg
func _ready():
	mlg = get_node("MultiLayer GridMap")
	var maps = []
	maps = mlg.gridmaps[0].get_used_cells()
	for t in maps:
		var tile = TileClass.instance()
		add_child(tile)
		tile.global_transform.origin = t
		var property = mlg.get_tile(t)
		if(property["blocked"] != null):
			tile.blocked = true
			tile._on_RigidBody_mouse_entered()
func world_to_map(p : Vector3):
	p -= translation
	var tSize = mapTiles[0].get_node("MeshInstance").mesh.size.x
	return Vector2(floor(p.x / tSize), floor(p.z / tSize))

func get_tile(pos : Vector2):
	return mapTiles[pos.y * width + pos.x]
func _process(delta):
	CameraManager.processCameraMovement(delta)