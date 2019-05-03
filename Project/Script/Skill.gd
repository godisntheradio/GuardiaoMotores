extends Object
class_name Skill
var name : String
var type : int
var effect : float = 1.0
var reach : int
var aoe : int
var anim : Animation


func _init():
	pass
func get_available_targets(battle_manager, origin) -> Array:
	var within_reach
	var within_reach_points = battle_manager.get_available_attack(origin)
	for point in within_reach_points:
		var tile : Tile = battle_manager.map.get_tile(Vector2(point.x, point.y))
		within_reach.append(tile)
	return within_reach
func get_aoe_tiles(battle_manager, origin) -> Array:
	var aoe = []
	aoe.append(origin)
	if (aoe == 1):
		return aoe
	
	return aoe
static func make_from_data(data):
	pass