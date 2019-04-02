extends Player
class_name Human

var turn : bool
var selecting_target : bool
var is_attacking : bool
var is_moving : bool
var selected_tile : Tile
var units_in_battle = []
var within_reach = [] # tiles within reach

var command_window
var player_input
var battle_manager

func _ready():
	turn = false
	command_window.connect("deselected",self,"on_deselected")
	command_window.connect("attack",self,"on_attack")
	command_window.connect("move",self,"on_move")
	is_attacking = false
	is_moving = false
	
func _input(event):
	if turn:
		if event is InputEventMouseButton && !event.pressed && event.button_index == BUTTON_LEFT:
			if(selecting_target): # selecionar ação quando tiver unidade selecionada
				if(player_input.result.size() > 0):
					var tile = player_input.result.collider.get_parent()
					if(tile is Tile):
						if(is_attacking):
							if(is_attack_valid(tile)):
								selected_tile.occupying_unit.attack(tile)
								after_move()
							else:
								print("cant attack tile" + tile.name)
						elif(is_moving):
							if(is_move_valid(tile)):
								var path = battle_manager.get_path_from_to(selected_tile, tile)
								var world_path : PoolVector3Array
								for point in path:
									world_path.append(battle_manager.map.get_tile(Vector2(point.x,point.y)).global_transform.origin)
								selected_tile.occupying_unit.move(tile, world_path)
								selected_tile.remove_unit()
								after_move()
			else: # selecionar unidade para selecionar ação
				if(player_input.result.size() > 0):
					var tile = player_input.result.collider.get_parent()
					if(tile is Tile && !tile.is_tile_empty()):
						on_selected(tile)
	
func _process(delta):
	pass
	
func begin_turn():
	print("begin turn")
	turn = true
	pass
func end_turn():
	turn = false
	pass
func on_selected(tile):
	if(selected_tile != null):
		selected_tile.deselect()
	selected_tile = tile
	selected_tile.select()
	command_window.visible = true
func on_deselected():
	selecting_target = false
	is_attacking = false
	is_moving = false
	selected_tile.deselect()
	selected_tile = null
	for tile in within_reach:
		tile.stop_highlight()
	within_reach = []
	command_window.visible = false
func on_attack():
	var within_reach_points = battle_manager.get_available_attack(selected_tile)
	for point in within_reach_points:
		var tile : Tile = battle_manager.map.get_tile(Vector2(point.x, point.y))
		tile.highlight_attackable()
		within_reach.append(tile)
	selecting_target = true
	is_attacking = true
func on_move():
	var within_reach_points = battle_manager.get_available_movement(selected_tile)
	for point in within_reach_points:
		var tile : Tile = battle_manager.map.get_tile(Vector2(point.x, point.y))
		tile.highlight_movable()
		within_reach.append(tile)
	selecting_target = true
	is_moving = true
func after_move():
	on_deselected()
func is_attack_valid(tile) -> bool:
	if(tile.is_tile_empty()):
		return false
	if(within_reach.has(tile)):
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




















