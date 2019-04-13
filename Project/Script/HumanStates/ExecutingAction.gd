extends State
class_name ExecutingAction
func _init(fsm).(fsm):
	pass
func action():
	pass
func entry_action():
	pass
func exit_action():
	get_fsm_owner().action_finished = false
static func get_name():
	return "Executing Action"