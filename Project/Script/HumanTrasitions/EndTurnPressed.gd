extends Transition
class_name EndTurnPressed
func _init(fsm).(fsm):
	pass
func entry_action():
	pass
func exit_action():
	print("saiu")
	get_fsm_owner().has_ended_turn = false
	get_fsm_owner().turn = false
	pass
func is_triggered():
	return get_fsm_owner().has_ended_turn