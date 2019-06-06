extends Player


var selected_tile : Tile
var selected_skill : Skill
var within_reach = [] # tiles within reach

var is_attacking : bool
var is_moving : bool
var tile_selected : bool
var target_selected : bool
var return_pressed : bool
var action_finished : bool
var has_ended_turn : bool

var command_window
var turn_window

var last_moved : Unit = null

var menu = preload("res://Objects/UI/Menu.tscn")
var menu_instance : Control = null

var state_machine : StateMachine
func initialize_state_machine():
	state_machine = StateMachine.new(self)
	
	var human_turn_s = HumanTurn.new(state_machine)
	var enemy_turn_s = EnemyTurn.new(state_machine)
	var waiting_battle_s = WaitingBattleStart.new(state_machine)
	var game_over_s = WaitingBattleStart.new(state_machine)
	
	var endturn_pressed_t = EndTurnPressed.new(state_machine)
	endturn_pressed_t.target_state = enemy_turn_s
	human_turn_s.add_transition(endturn_pressed_t)
	
	var turnBegun_t = TurnBegun.new(state_machine)
	turnBegun_t.target_state = human_turn_s
	enemy_turn_s.add_transition(turnBegun_t)
	
	var battleStarted_t = BattleStarted.new(state_machine)
	battleStarted_t.target_state = human_turn_s
	waiting_battle_s.add_transition(battleStarted_t)
	
	var game_over_t = GameOverTransition.new(state_machine)
	game_over_t.target_state = game_over_s
	enemy_turn_s.add_transition(game_over_t)
	human_turn_s.add_transition(game_over_t)
	
	state_machine.add_state(human_turn_s)
	state_machine.add_state(enemy_turn_s)
	state_machine.add_state(waiting_battle_s)
	state_machine.add_state(game_over_s)
	state_machine.initial_state = waiting_battle_s
	
	state_machine.start()
	
func _ready():
	turn = false
	command_window.connect("returning",self,"on_return")
	command_window.connect("attack",self,"on_attack")
	command_window.connect("move",self,"on_move")
	
	is_attacking = false
	is_moving = false
	tile_selected = false
	target_selected = false
	return_pressed = false
	action_finished = false
	has_ended_turn = false
func _input(event):
	state_machine.update_input(event)
	if (event is InputEventKey && event.pressed == true && event.scancode == KEY_ESCAPE):
		if(menu_instance == null):
			menu_instance = menu.instance()
			battle_manager.add_child(menu_instance)
		else:
			menu_instance.queue_free()
			menu_instance = null
		
func _process(delta):
	state_machine.update(delta)
func begin_turn():
	turn_window.visible = true
	turn = true
func end_turn():
	turn_window.visible = false
	reset_units()
	last_moved = null
	has_ended_turn = true
	command_window.hide_commands()
	
func select_unit(tile):
	if(selected_tile != null):
		selected_tile.deselect()
	selected_tile = tile
	selected_tile.select() # muda efeito visual do tile
	command_window.show_commands(selected_tile.occupying_unit)
func deselect_unit():
	if selected_tile != null:
		selected_tile.deselect()
		selected_tile = null
		command_window.hide_commands()
func deselect_action():
	is_attacking = false
	is_moving = false
	for tile in within_reach:
		tile.stop_highlight()
	within_reach = []

# eventos
func on_attack(skill_id):
	deselect_action()
	within_reach.clear()
	selected_skill = selected_tile.occupying_unit.stats.skills[skill_id]
	within_reach = selected_skill.get_available_targets(battle_manager, selected_tile)
	for tile in within_reach:
		match (selected_skill.type):
			Skill.Attack:
				tile.highlight_attackable()
			Skill.Heal:
				tile.highlight_curable()
	is_attacking = true
func on_move():
	deselect_action()
	within_reach.clear()
	var within_reach_points = battle_manager.get_available_movement(selected_tile.occupying_unit)
	for point in within_reach_points:
		var tile : Tile = battle_manager.map.get_tile(Vector2(point.x, point.y))
		tile.highlight_movable()
		within_reach.append(tile)
	is_moving = true
func on_return():
	return_pressed = true
	
func on_unit_finished_action():
	action_finished = true

func after_move():
	deselect_unit()
	deselect_action()
	
func is_attack_valid(tile) -> bool:
	match(selected_skill.type):
		Skill.Attack:
			if(tile.is_tile_empty()):
				return false
			if(within_reach.has(tile) && tile.occupying_unit.player != self):
				return true
			else:
				return false
		Skill.Heal:
			if(tile.is_tile_empty()):
				return false
			if(within_reach.has(tile) && tile.occupying_unit.player == self):
				return true
			else:
				return false
func is_aoe_valid(tile)->bool:
	match(selected_skill.type):
		Skill.Attack:
			if(tile.is_tile_empty()):
				return false
			if(tile.occupying_unit.player != self):
				return true
			else:
				return false
		Skill.Heal:
			if(tile.is_tile_empty()):
				return false
			if(tile.occupying_unit.player == self):
				return true
			else:
				return false

func is_move_valid(tile) -> bool:
	if(!tile.is_tile_empty()):
		return false
	if(within_reach.has(tile)):
		return true
	else:
		return false

func undo_move():
	if last_moved != null:
		var pos = battle_manager.map.world_to_map(last_moved.global_transform.origin)
		battle_manager.map.get_tile(pos).remove_unit()
		battle_manager.map.get_tile(last_moved.start_pos).occupying_unit = last_moved
		last_moved.undo_move(battle_manager.map.get_tile(last_moved.start_pos).global_transform.origin)
		battle_manager.astarManager.update_connections()

