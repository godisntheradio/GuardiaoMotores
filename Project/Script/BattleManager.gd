extends Spatial

var UnitClass = preload("res://Objects/Unit.tscn")
var input
var map

var to_be_positioned

func _ready():
	map = get_tree().get_root().get_node("Main/Map")
	input = get_tree().get_root().get_node("Main/PlayerInput")
	pass # Replace with function body.
func _physics_process(delta):
	if(to_be_positioned != null):
		if(input.result.size() > 0):
			var tile = input.result.collider.get_parent()
			if(tile is Tile):
				to_be_positioned.global_transform.origin = tile.global_transform.origin + Vector3(0,3.0,0)
		else:
			to_be_positioned.global_transform.origin = input.dir.normalized() * 2
	pass
func position_unit(new_unit : Unit, tile : Tile):
	new_unit.translation = tile.global_transform.origin + Vector3(0,5.0,0)
	pass
	
func make_unit(stats):
	var instance = UnitClass.instance()
	get_tree().get_root().get_node("Main").add_child(instance)
	instance.stats = stats
	instance.hp = stats.hit_points
	return instance
func _on_selected_from_list(index):
	if(to_be_positioned != null):
		to_be_positioned.free()
	to_be_positioned =  make_unit(PlayerData.available_units[index])
	pass