extends Skill
class_name CrossSkill
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