extends Transition
class_name ReturnPressed
func _init(fsm).(fsm):
	pass
func entry_action():
	get_fsm_owner().return_pressed = false
func exit_action():
	get_fsm_owner().return_pressed = false
func is_triggered():
	return get_fsm_owner().return_pressed