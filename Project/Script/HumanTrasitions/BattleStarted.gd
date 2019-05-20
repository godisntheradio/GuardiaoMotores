extends Transition
class_name BattleStarted
func _init(fsm).(fsm):
	pass
func entry_action():
	pass
func exit_action():
	print("battle started")
	pass
func is_triggered():
	return get_fsm_owner().battle_manager.has_started