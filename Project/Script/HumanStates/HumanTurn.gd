extends State
class_name HumanTurn
var sub_fsm

func _init(fsm).(fsm):
	self.fsm = fsm
	sub_fsm = StateMachine.new(get_fsm_owner())
	
	var unit_s = SelectingUnit.new(sub_fsm) # initialize states
	var action_s = SelectingAction.new(sub_fsm)
	var Atarget_s = SelectingAttackTarget.new(sub_fsm)
	var Mtarget_s = SelectingMoveTarget.new(sub_fsm)
	var exe_s = ExecutingAction.new(sub_fsm)
	
	var unit_selected_t = UnitSelected.new(sub_fsm) # initialize transitions
	var attack_selected_t = AttackSelected.new(sub_fsm)
	var move_selected_t = MoveSelected.new(sub_fsm)
	var return_to_unit_t = ReturnPressed.new(sub_fsm)
	var return_to_action_t = ReturnPressed.new(sub_fsm)
	var target_selected_t = TargetSelected.new(sub_fsm)
	var action_finished_t = ActionFinished.new(sub_fsm)
	
	unit_selected_t.target_state = action_s # set target states and assign to states
	unit_s.add_transition(unit_selected_t)
	
	attack_selected_t.target_state = Atarget_s
	action_s.add_transition(attack_selected_t)
	
	move_selected_t.target_state = Mtarget_s
	action_s.add_transition(move_selected_t)
	
	target_selected_t.target_state = exe_s
	Atarget_s.add_transition(target_selected_t)
	Mtarget_s.add_transition(target_selected_t)
	
	action_finished_t.target_state = unit_s
	exe_s.add_transition(action_finished_t)
	
	return_to_unit_t.target_state = unit_s
	action_s.add_transition(return_to_unit_t)
	
	return_to_action_t.target_state = action_s
	Mtarget_s.add_transition(return_to_action_t)
	Atarget_s.add_transition(return_to_action_t)
	
	sub_fsm.add_state(unit_s)
	sub_fsm.add_state(action_s)
	sub_fsm.add_state(Atarget_s)
	sub_fsm.add_state(Mtarget_s)
	sub_fsm.add_state(exe_s)
	
	sub_fsm.initial_state = unit_s
	sub_fsm.start()
func action(delta):
	CameraManager.processCameraMovement(delta)
	sub_fsm.update_input(fsm.input_event)
	sub_fsm.update(delta)
	
func entry_action():
	pass
func exit_action():
	pass
static func get_name():
	return "Human Turn"