extends Task
class_name TaskAttack
var agent_skill
func _init(agent_, target_:Tile, manager_, skill_).(agent_,target_,manager_):
	agent_skill = skill_
	self.in_reach = in_reach(agent_skill)
	self.in_range = in_range()
func calculate_score() -> int:
	score = target_in_range()
	score += low_hp_target()
	score += low_hp_agent()
	score += target_in_reach()
	return score
	
func execute_task():
	agent.attack(target, agent_skill)
func target_in_range() -> int:
	var max_score = 100
	if(!in_range):
		return -max_score
	return max_score
func target_in_reach() -> int:
	var max_score = 100
	if(!in_reach):
		return -max_score
	return max_score
func low_hp_target() ->int:
	var max_score = 100
	return max_score -( (target.occupying_unit.hp / target.occupying_unit.stats.hit_points) * max_score)
func low_hp_agent() -> int:
	var max_score = 100
	return -max_score + ((agent.hp / agent.stats.hit_points) * max_score)
func units_in_aoe() -> int:
	var max_score = 50
	if(agent_skill.aoe == 0):
		return 0
	var tiles = agent_skill.get_aoe_tiles(manager, target)
	var count = 0
	for t in tiles:
		if(t.occupying_unit != agent && t.occupying_unit != target.occupying_unit):
			count = count + 1
	return 50 * count
func in_range() -> bool:
	var attack_range = agent.stats.movement + agent_skill.reach
	var user_tile = manager.map.get_tile(manager.map.world_to_map(agent.global_transform.origin))
	var dist = manager.get_distance_from_to(user_tile, target)
	if(dist < attack_range):
		return true
	return false