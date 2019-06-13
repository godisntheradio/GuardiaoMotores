extends State
class_name AITurn
var sub_fsm : StateMachine
var follow_speed = 5
func _init(fsm).(fsm):
	self.fsm = fsm
	sub_fsm = StateMachine.new(get_fsm_owner())
	
	var assigning_s = AssigningTasks.new(sub_fsm)
	var exe_s = ExecutingAction.new(sub_fsm)
	
	var action_finished_t = ActionFinished.new(sub_fsm)
	var has_task_t = HasTaskAssigned.new(sub_fsm)
	
	assigning_s.add_transition(has_task_t)
	has_task_t.target_state = exe_s
	
	exe_s.add_transition(action_finished_t)
	action_finished_t.target_state = assigning_s
	
	sub_fsm.add_state(assigning_s)
	sub_fsm.add_state(exe_s)
	
	sub_fsm.initial_state = assigning_s
	
func action(delta):
	if (get_fsm_owner().choosen_agent != null):
		CameraManager.relocate(lerp(CameraManager.global_transform.origin, get_fsm_owner().choosen_agent.global_transform.origin, delta * follow_speed))
#	CameraManager.processCameraMovement(delta)
	sub_fsm.update_input(fsm.input_event)
	sub_fsm.update(delta)
func entry_action():
	get_fsm_owner().task_list = []
	sub_fsm.start()
func exit_action():
	get_fsm_owner().battle_manager.check_game_over()
	pass
static func get_name():
	return "AI Turn"