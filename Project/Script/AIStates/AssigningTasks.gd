extends State
class_name AssigningTasks
var tasks
func _init(fsm).(fsm):
	pass
func action(delta):
	get_fsm_owner().choosen_agent = choose_agent()
	if(get_fsm_owner().choosen_agent == null):
		get_fsm_owner().battle_manager.on_end_player_turn()
	else:
		create_tasks()
		choose_task()
func entry_action():
	pass
func exit_action():
	if get_fsm_owner().task_list.size() > 1:
		if get_fsm_owner().task_list[0] == get_fsm_owner().task_list[1]:
			print("before pop:" +str( get_fsm_owner().task_list))
	var to_exe = get_fsm_owner().task_list.pop_front()
	to_exe.execute_task()
	print("after pop:" +str( get_fsm_owner().task_list))
	
static func get_name():
	return "Assigning Tasks"
func choose_agent():
	if (get_fsm_owner().choosen_agent != null):
		if (get_fsm_owner().choosen_agent.has_attacked && get_fsm_owner().choosen_agent.has_moved):
			pass
		else:
			return get_fsm_owner().choosen_agent
	for unit in get_fsm_owner().units:
		if(!unit.has_attacked || !unit.has_moved):
			return unit
	return null
func create_tasks():
	tasks = []
	var enemies = get_fsm_owner().battle_manager.get_enemy_units(get_fsm_owner())
	for skill in get_fsm_owner().choosen_agent.stats.skills:
		match skill.type:
			Skill.Heal:
				for unit in get_fsm_owner().units:
					var t = TaskCure.new(get_fsm_owner().choosen_agent, get_fsm_owner().battle_manager.get_tile_from_unit(unit),get_fsm_owner().battle_manager,skill)
					t.in_reach = t.in_reach(skill)
					t.calculate_score()
					tasks.append(t)
			Skill.Attack:
				for e in enemies:
					var t = TaskAttack.new(get_fsm_owner().choosen_agent, get_fsm_owner().battle_manager.get_tile_from_unit(e),get_fsm_owner().battle_manager,skill)
					t.in_reach = t.in_reach(skill)
					t.calculate_score()
					tasks.append(t)
func choose_task():
	if (tasks.size() > 0):
		var best = tasks[0]
		for t in tasks:
			if(t.score > best.score):
				best = t
		if(!best.in_reach):
			if(get_fsm_owner().choosen_agent.has_moved):
				get_fsm_owner().choosen_agent.has_attacked = true
			else:
				var move_task = create_move_task(best)
				get_fsm_owner().task_list.push_front(move_task)
		else:
			get_fsm_owner().task_list.append(best)
func create_move_task(target_task) -> Task:
	var available_neighbors = target_task.agent_skill.get_available_targets(get_fsm_owner().battle_manager,target_task.target)
	var available_movement = get_fsm_owner().battle_manager.get_available_movement(target_task.agent)
	var closest = null
	var dist = 1000
	var intersection = []
	
	var move_task_list = []
	for m in available_movement:
		var t = get_fsm_owner().battle_manager.map.get_tile(Vector2(m.x, m.y))
		t.highlight_movable()
		for n in available_neighbors:
			n.highlight_attackable()
			if (t == n):
				intersection.append(t)
		var current = t.global_transform.origin.distance_to(target_task.target.global_transform.origin)
		if( current < dist):
			closest = t
			dist = current
	closest.highlight_curable()
	if(intersection.size() > 0):
		for i in intersection:
			var move_t = TaskMove.new(target_task.agent,i, target_task.manager)
			move_t.calculate_score()
			move_task_list.append(move_t)
	else:
		var move_t = TaskMove.new(target_task.agent, closest,target_task.manager)
		move_t.calculate_score()
		return move_t
	var b = move_task_list[0]
	for t in tasks:
		if(t.score > b.score):
			b = t
	return b