extends State
class_name ExecutingAction
func _init(fsm).(fsm):
	pass
func action(delta):
	pass
func entry_action():
	pass
func exit_action():
	get_fsm_owner().action_finished = false
	get_fsm_owner().battle_manager.check_game_over()
	print("aqui")
static func get_name():
	return "Executing Action"