extends Skill
class_name CrossSkill
func get_available_targets(battle_manager, origin) -> Array:
	var within_reach = []
	var within_reach_points = battle_manager.get_available_attack(origin.occupying_unit, reach)
	var ignore_points
	for point in within_reach_points:
		var tile : Tile = battle_manager.map.get_tile(Vector2(point.x, point.y))
		if ((tile.global_transform.origin.x < origin.global_transform.origin.x + 2 && tile.global_transform.origin.x > origin.global_transform.origin.x - 2) || (tile.global_transform.origin.z < origin.global_transform.origin.z + 2 && tile.global_transform.origin.z > origin.global_transform.origin.z - 2)): 
			within_reach.append(tile)
	if(ignore > 0):
		ignore_points = battle_manager.get_available_attack(origin.occupying_unit, ignore)
		for point in ignore_points:
			var tile : Tile = battle_manager.map.get_tile(Vector2(point.x, point.y))
			var index = within_reach.find(tile)
			if(index != -1):
				print(index)
				within_reach.remove(index)
	return within_reach
