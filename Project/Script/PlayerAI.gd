extends Player
var state_machine : StateMachine

var action_finished : bool
var has_ended_turn : bool

var task_list : Array
var choosen_agent : Unit

func _ready():
	turn = false
	task_list = []
	choosen_agent = null
	action_finished = false
	has_ended_turn = false
func begin_turn():
	turn = true
func _process(delta):
	if Input.is_action_just_pressed("left_click") && turn:
		battle_manager.on_end_player_turn()
	state_machine.update(delta)
func end_turn():
	turn = false
	has_ended_turn = true
	reset_units()
func initialize_state_machine():
	state_machine = StateMachine.new(self)
	
	var enemy_turn_s = EnemyTurn.new(state_machine)
	var waiting_battle_s = WaitingBattleStart.new(state_machine)
	var ai_turn_s = AITurn.new(state_machine)
	
	var battleStarted_t = BattleStarted.new(state_machine)
	var no_more_tasks_t = EndTurnPressed.new(state_machine)
	var turnBegun_t = TurnBegun.new(state_machine)
	
	waiting_battle_s.add_transition(battleStarted_t)
	battleStarted_t.target_state = enemy_turn_s
	
	ai_turn_s.add_transition(no_more_tasks_t)
	no_more_tasks_t.target_state = enemy_turn_s
	
	enemy_turn_s.add_transition(turnBegun_t)
	turnBegun_t.target_state = ai_turn_s
	
	state_machine.add_state(waiting_battle_s)
	state_machine.add_state(ai_turn_s)
	state_machine.add_state(enemy_turn_s)
	state_machine.initial_state = waiting_battle_s
	
	state_machine.start()
	
func on_unit_finished_action():
	action_finished = true
	