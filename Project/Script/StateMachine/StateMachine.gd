extends Object
class_name StateMachine
var state_list : Array  = []
var owner : Node

var initial_state : State
var current_state : State

var input_event

func _init(owner : Node):
	self.owner = owner
	
func start():
	current_state = initial_state
	current_state.entry_action()
	pass
func update():
	if (current_state != null):
		var triggered_transition = null
		for transition in current_state.transitions:
			if (transition.is_triggered()):
				triggered_transition = transition
		if (triggered_transition != null):
			triggered_transition.entry_action();
			var target_state = triggered_transition.target_state
			current_state.exit_action()
			triggered_transition.exit_action()
			target_state.entry_action()
			current_state = target_state
		else:
			current_state.action()
	pass
func add_state(state : State):
	state_list.append(state)
	pass
func update_input(event):
	input_event = event