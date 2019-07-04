extends Task
class_name TaskNothing

func _init(agent_:Unit, target_:Tile, manager_).(agent_,target_,manager_):
	self.in_range = in_range()
func calculate_score() -> int:
	score = target_in_range()
	return score
	
func execute_task():
	agent.do_nothing()
func target_in_range() -> int:
	var max_score = 1000
	if(!in_range):
		return max_score
	return -max_score
func in_range() -> bool:
	var enemy = manager.get_enemy_units(agent.player)
	var dists = []
	var user_tile = manager.map.get_tile(manager.map.world_to_map(agent.global_transform.origin))
	for e in enemy:
		var enemy_tile = manager.map.get_tile(manager.map.world_to_map(e.global_transform.origin))
		var dist = manager.get_distance_from_to(user_tile, enemy_tile)
		dists.append(dist)
	var ranges = []
	var found = false
	for s in agent.stats.skills:
		if(s.type == Skill.Attack):
			var attack_range = agent.stats.movement + s.reach
			attack_range = attack_range * 3
			ranges.append(attack_range)
	for i in dists:
		for r in ranges:
			if(i <= r):
				found = true
	if(found):
		return true
	self.in_reach = false
	return false