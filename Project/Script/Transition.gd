extends Object
class_name Transition

var fsm 
var target_state 

func _init(fsm):
	self.fsm = fsm
func entry_action():
	pass
func exit_action():
	pass
func is_triggered():
	pass
func get_fsm_owner() -> Node:
	return fsm.owner