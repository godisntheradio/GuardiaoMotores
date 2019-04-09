extends Spatial
class_name Player
var units = []
var battle_manager

func begin_turn():
	pass
func end_turn():
	pass
func remove_unit(unit):
	var mappos = battle_manager.map.world_to_map(unit.global_transform.origin)
	print(mappos)
	battle_manager.map.get_tile(mappos).remove_unit()
	units.remove(units.find(unit))
func reset_units():
	for unit in units:
		unit.reset()
func on_unit_finished_action():
	pass