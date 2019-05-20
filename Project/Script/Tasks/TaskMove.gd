extends Task
class_name TaskMove
func _init(agent_:Unit, target_:Tile, manager_).(agent_,target_,manager_):
	pass
func calculate_score() -> int:
	return int(agent.global_transform.origin.distance_to(target.global_transform.origin))
	
func execute_task():
	var agent_tile = manager.map.get_tile(manager.map.world_to_map(agent.global_transform.origin))
	var path = manager.get_path_from_to(agent_tile, target)
	var world_path : PoolVector3Array
	for point in path:
		world_path.append(manager.map.get_tile(Vector2(point.x,point.y)).translation)
	agent.move(target, world_path)
	agent_tile.remove_unit()
	manager.astarManager.update_connections()