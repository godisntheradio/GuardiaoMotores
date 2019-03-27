extends Spatial

var UnitClass = preload("res://Objects/Unit.tscn")
var map

# Called when the node enters the scene tree for the first time.
func _ready():
	#map = get_tree().get_root().get_node("Map") as Map
	pass # Replace with function body.

func position_unit(new_unit : Unit, tile : Tile):
	new_unit.translation = tile.pos + Vector3(0,5.0,0)
	pass
func make_unit(stats):
	var instance = UnitClass.instance()
	instance.stats = stats
	instance.hp = stats.hit_points
	return instance