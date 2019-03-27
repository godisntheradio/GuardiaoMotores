extends Spatial
class_name Map
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var TileClass = preload("res://Objects/Tile.tscn")
var mapTiles : Array = []
export var width : int
export var height : int
# Called when the node enters the scene tree for the first time.
func _ready():
	for x in range(10):
		for y in range(10):
			var instance = TileClass.instance()
			var mesh = instance.get_node("MeshInstance").mesh
			add_child(instance)
			instance.translate(Vector3(translation.x + mesh.size.x * x, 0 , translation.z + mesh.size.z * y ))
			mapTiles.append(instance)
			instance.name = instance.name + str(x) + str(y)
			if(y == 1 && x == 1):
				var unit = get_tree().get_root().get_node("Main/Unit")
				unit.global_transform.origin = instance.global_transform.origin
				unit.translate(Vector3(0,2,0))
				instance.occupying_unit = unit
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
