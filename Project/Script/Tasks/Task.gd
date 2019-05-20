extends Object
class_name Task


var agent: Unit
var target : Tile
var score : int
var manager 
var in_reach : bool
func _init(agent_:Unit, target_:Tile, manager_):
	self.agent = agent_
	self.target = target_
	self.manager = manager_
	self.score = 0
func calculate_score() -> int:
	return 0
	
func execute_task():
	pass
func in_range_for_attack(user : Unit, to_attack : Tile) -> bool:
	for skill in user.stats.skills:
		if(skill.type == Skill.Attack):
			var attack_range = user.stats.movement + skill.reach
			if((to_attack.global_transform.origin.distance_to(user.global_transform.origin) + 1)/2 < attack_range):
				return true
	return false
func in_range_for_heal(user : Unit, to_attack : Tile) -> bool:
	for skill in user.stats.skills:
		if(skill.type == Skill.Heal):
			var attack_range = user.stats.movement + skill.reach
			if((to_attack.global_transform.origin.distance_to(user.global_transform.origin) + 1)/2 < attack_range):
				return true
	return false
func in_reach(skill : Skill) -> bool:
	var attack_range = skill.get_available_targets(manager, manager.map.get_tile(manager.map.world_to_map(agent.global_transform.origin)))
	for t in attack_range:
		if(t == target):
			return true
	return false