extends Object
class_name Task


var agent: Unit
var target : Tile
var score : int
var manager 
var in_reach : bool
var in_range : bool
func _init(agent_:Unit, target_:Tile, manager_):
	self.agent = agent_
	self.target = target_
	self.manager = manager_
	self.score = int( calculate_score())
func calculate_score() -> int:
	return 0
func execute_task():
	pass
func in_reach(skill : Skill) -> bool:
	var attack_range = skill.get_available_targets(manager, manager.map.get_tile(manager.map.world_to_map(agent.global_transform.origin)))
	for t in attack_range:
		if(t == target):
			return true
	return false