extends Player
class_name Human

var turn : bool
var selected_tile : Tile
var within_reach = [] # tiles within reach

var is_attacking : bool
var is_moving : bool
var tile_selected : bool
var target_selected : bool
var return_pressed : bool
var action_finished : bool

var command_window
var player_input
var turn_window

var last_moved : Unit = null

func _ready():
	turn = false
	command_window.connect("return",self,"on_return")
	command_window.connect("attack",self,"on_attack")
	command_window.connect("move",self,"on_move")
	
	is_attacking = false
	is_moving = false
	tile_selected = false
	target_selected = false
	return_pressed = false
	action_finished = false
func _input(event):
	if turn:
		if event is InputEventMouseButton && !event.pressed && event.button_index == BUTTON_RIGHT:
        	undo_move()
	
func begin_turn():
	turn_window.visible = true
	turn = true
	pass
func end_turn():
	turn_window.visible = false
	turn = false
	reset_units()
	last_moved = null
	
func select_unit(tile):
	if(selected_tile != null):
		selected_tile.deselect()
	selected_tile = tile
	selected_tile.select() # muda efeito visual do tile
	command_window.visible = true #cuida da visibilidade da janela de comandos
	command_window.move_in()
	if(selected_tile.occupying_unit.has_attacked):
		command_window.hide_attack()
	if(selected_tile.occupying_unit.has_moved):
		command_window.hide_move()
func deselect_unit():
	selected_tile.deselect()
	selected_tile = null
	command_window.visible = false
func deselect_action():
	is_attacking = false
	is_moving = false
	for tile in within_reach:
		tile.stop_highlight()
	within_reach = []

# eventos
func on_attack():
	within_reach.clear()
	var within_reach_points = battle_manager.get_available_attack(selected_tile.occupying_unit)
	for point in within_reach_points:
		var tile : Tile = battle_manager.map.get_tile(Vector2(point.x, point.y))
		tile.highlight_attackable()
		within_reach.append(tile)
	is_attacking = true
func on_move():
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
	if(tile.is_tile_empty()):
		return false
	if(within_reach.has(tile) && tile.occupying_unit.player != self):
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


















