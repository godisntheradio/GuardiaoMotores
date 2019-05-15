extends Task
class_name TaskCure
var agent_skill : Skill
func _init(agent_:Unit, target_:Tile, manager_, skill_ : Skill).(agent_,target_,manager_):
	agent_skill = skill_
	pass
func calculate_score() -> int:
	return 0
	
func execute_task():
	pass
func target_in_range() -> int:
	var attack_range = agent.stats.movement + agent_skill.reach
	return 0