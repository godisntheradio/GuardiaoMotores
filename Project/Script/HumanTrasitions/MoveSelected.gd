extends Transition
class_name MoveSelected
func _init(fsm).(fsm):
	pass
func entry_action():
	pass
func exit_action():
	pass
func is_triggered():
	return get_fsm_owner().is_moving