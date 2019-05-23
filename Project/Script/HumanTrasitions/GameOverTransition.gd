extends Transition
class_name GameOverTransition

func _init(fsm).(fsm):
	pass
func entry_action():
	pass
func exit_action():
	pass
func is_triggered():
	return get_fsm_owner().battle_manager.winner >= 0