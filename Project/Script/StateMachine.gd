class StateMachine extends Object:
	var state_list : Array  = []
	var owner : Node
	
	var initial_state : State
	var current_state : State
	
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
class State extends Object:
	var fsm : StateMachine
	var transitions : Array = []
	
	var state_name : String
	
	func _init(fsm):
		self.fsm = fsm
	func action():
		pass
	func entry_action():
		pass
	func exit_action():
		pass
	func get_name():
		pass
	func add_transition(transition : Transition):
		transitions.append(transition)
		pass
class Transition extends Object:
	var fsm
	var target_state : State
	
	func _init(fsm):
		self.fsm = fsm
	func entry_action():
		pass
	func exit_action():
		pass
	func is_triggered():
		pass