extends Transition

func entry_action():
	get_fsm_owner().return_pressed = false
func exit_action():
	get_fsm_owner().return_pressed = false
func is_triggered():
	return get_fsm_owner().return_pressed