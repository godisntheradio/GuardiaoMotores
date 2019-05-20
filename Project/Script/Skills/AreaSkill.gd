extends Skill
class_name AreaSkill
func get_available_targets(battle_manager, origin) -> Array:
	var within_reach = []
	var within_reach_points = battle_manager.get_available_attack(origin.occupying_unit, reach)
	var ignore_points
	for point in within_reach_points:
		var tile : Tile = battle_manager.map.get_tile(Vector2(point.x, point.y))
		within_reach.append(tile)
	if(ignore > 0):
		ignore_points = battle_manager.get_available_attack(origin.occupying_unit, ignore)
		for point in ignore_points:
			var tile : Tile = battle_manager.map.get_tile(Vector2(point.x, point.y))
			var index = within_reach.find(tile)
			within_reach.remove(index)
	return within_reach
