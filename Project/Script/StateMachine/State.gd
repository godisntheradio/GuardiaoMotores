extends Object
class_name State
var fsm
var transitions : Array 

var state_name : String

func _init(fsm):
	self.fsm = fsm
	transitions = []
func action(delta):
	pass
func entry_action():
	pass
func exit_action():
	pass
static func get_name():
	pass
func add_transition(transition):
	transitions.append(transition)
	pass
func get_fsm_owner() -> Node:
	return fsm.owner