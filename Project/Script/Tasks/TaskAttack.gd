extends Task
class_name TaskAttack
var agent_skill : Skill
func _init(agent_:Unit, target_:Tile, manager_, skill_ : Skill).(agent_,target_,manager_):
	agent_skill = skill_
	pass
func calculate_score() -> int:
	score += target_in_range()
	score += low_hp_target()
	score += low_hp_agent()
	return score
	
func execute_task():
	agent.attack(target)
func target_in_range() -> int:
	var max_score = 100
	if(!in_range_for_attack(agent,target)):
		return -max_score
	return max_score
func low_hp_target() ->int:
	var max_score = 100
	return (target.occupying_unit.hp / target.occupying_unit.stats.hit_points) * max_score
func low_hp_agent() -> int:
	var max_score = 100
	return - ((agent.hp / agent.stats.hit_points) * max_score)
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