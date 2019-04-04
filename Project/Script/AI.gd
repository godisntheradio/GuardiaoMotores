extends Player

var has_turn : bool = false

var tasks = []
var curr_task = 0

func _ready():
	pass
func begin_turn():
	has_turn = true
	assign_tasks()
	
func _process(delta):
	if has_turn:
		if curr_task >= tasks.size():
			battle_manager.on_end_player_turn()
			return
		
		if curr_task > 0:
			if tasks[curr_task-1].unit.is_moving:
				return
		
		execute_task(tasks[curr_task])
		curr_task += 1
		
func end_turn():
	tasks.clear()
	curr_task = 0
	reset_units()
	pass
func assign_tasks():
	print(units.size())
	for unit in units:
		tasks.append(choose_task(unit))

func choose_task(unit : Unit):
	var tasks = []
	var mov = battle_manager.get_available_movement(unit)
	var found_units = []
	for t in mov:
		var atk = battle_manager.astarManager.get_available_movement(t, 1, true, false)
		for a in atk:
			var a_tile = battle_manager.map.get_tile(a)
			if !a_tile.is_tile_empty() && a_tile.occupying_unit.player != self && !found_units.has(a_tile.occupying_unit):
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
	if task.in_range:
		var neighbours = battle_manager.get_available_attack(task.target)
		for n in neighbours:
			var n_tile = battle_manager.map.get_tile(n)
			if move_tile == null:
				move_tile = n_tile
			else:
				var mt_dist = move_tile.global_transform.origin.distance_to(task.unit.global_transform.origin)
				var n_dist = n_tile.global_transform.origin.distance_to(task.unit.global_transform.origin)
				if n_dist < mt_dist:
					move_tile = n_tile
	else:
		var mov = battle_manager.get_available_movement(task.target)
		for t in mov:
			var tile = battle_manager.map.get_tile(t)
			if move_tile == null:
				move_tile = tile
			else:
				var mt_dist = move_tile.global_transform.origin.distance_to(task.target.global_transform.origin)
				var tile_dist = tile.global_transform.origin.distance_to(task.target.global_transform.origin)
				if tile_dist < mt_dist:
					move_tile = tile
				
	if move_tile == null:
		return
		
	var unit_tile = battle_manager.map.get_tile(battle_manager.map.world_to_map(task.unit.global_transform.origin))
	var path = battle_manager.get_path_from_to(unit_tile, move_tile)
	var world_path : PoolVector3Array
	var tileSize = unit_tile.get_node("MeshInstance").mesh.size.x
	for point in path:
		world_path.append(battle_manager.map.get_tile(Vector2(point.x,point.y)).translation)
	task.unit.move(move_tile, world_path)
	unit_tile.remove_unit()
	battle_manager.astarManager.update_connections()
	
	if(task.in_range):
		var target_tile = battle_manager.map.get_tile(battle_manager.map.world_to_map(task.target.global_transform.origin))
		task.unit.attack(target_tile)

class Task:
	var target : Unit = null
	var score : int = 0
	var unit : Unit = null
	var in_range : bool = false
	var map : Map = null
	
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
	