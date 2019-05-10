extends Object
class_name Skill
enum {Attack, Heal}

var name : String
var type : int
var effect : float = 1.0
var reach : int
var aoe : int
var ignore : int
var anim : Animation


func _init():
	pass
func get_available_targets(battle_manager, origin) -> Array:
	return []
func get_aoe_tiles(battle_manager, origin) -> Array:
	var aoe_tiles = []
	aoe_tiles.append(origin)
	if (aoe <= 1):
		return aoe_tiles
	var points = battle_manager.get_neighbors(origin, aoe)
	for point in points:
		var tile : Tile = battle_manager.map.get_tile(Vector2(point.x, point.y))
		aoe_tiles.append(tile)
	return aoe_tiles
func calculate_effect(stats):
	match type:
		Heal:
			heal(stats)
		Attack:
			attack(stats)
func heal(stats):
	return 10
func attack(stats):
	return -10