extends Transition

func entry_action():
	pass
func exit_action():
	pass
func is_triggered():
	return get_fsm_owner().tile_selected