extends Player

func _ready():
	pass
func begin_turn():
	assign_tasks()
	battle_manager.on_end_player_turn()
func end_turn():
	reset_units()
	pass
func assign_tasks():
	for unit in units:
		var task = choose_task(unit)
		execute_task(task)
func choose_task(unit : Unit):
	var tasks = []
	var mov = battle_manager.get_available_movement(unit)
	var found_units = []
	for t in mov:
		var atk = battle_manager.astarManager.get_available_movement(t, 1, true, false)
		for a in atk:
			var a_tile = battle_manager.map.get_tile(a)
			if !a_tile.is_tile_empty() && !found_units.has(a_tile.occupying_unit):
				found_units.append(a_tile.occupying_unit)
	var rest = []
	for e in battle_manager.get_enemy_units(self):
		if !found_units.has(e):
			rest.append(e)
	
	for fu in found_units:
		tasks.append(Task.new(unit, fu, battle_manager.map))
		tasks.back().in_range = true
	for r in rest:
		tasks.append(Task.new(unit, r, battle_manager.map))
	
	var best_task = tasks[0]
	for t in tasks:
		if t.score > best_task.score:
			best_task = t
	
	return best_task
	
func execute_task(task : Task):
	var move_tile = null
	if in_range:
		var neighbours = battle_manager.get_available_attack(task.target)
		for n in neighbours:
			
	
	var path = battle_manager.get_path_from_to(selected_tile, tile)
	var world_path : PoolVector3Array
	var tileSize = selected_tile.get_node("MeshInstance").mesh.size.x
	for point in path:
		world_path.append(battle_manager.map.get_tile(Vector2(point.x,point.y)).translation)
	selected_tile.occupying_unit.move(tile, world_path)
	selected_tile.remove_unit()
	after_move()
	battle_manager.astarManager.update_connections()

class Task:
	var target : Unit
	var score
	var unit : Unit
	var in_range : bool
	var map : Map
	
	func _init(unit, target, map):
		self.target = target
		self.unit = unit
		self.map = map
	func calculate_score() -> int:
		score += distance_to()
		score += lower_hp()
		return score
	func distance_to() -> int:
		var max_score = 100
		if in_range:
			return max_score
		var distance = unit.global_transform.origin.distance_to(target.global_transform.origin) - 1
		var tile_distance = distance / 2
		var max_distance = Vector2(0, 0).distance_to(Vector2(map.width, map.height))
		
		return max_score - (tile_distance / max_distance * max_score)
	func lower_hp() -> int:
		var max_score = 50
		var max_hp = 100
		
		return max_score - (target.hp / max_hp * max_score)
	