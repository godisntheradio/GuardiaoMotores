extends Player
class_name Human

var turn : bool
var selecting_target : bool
var is_attacking : bool
var is_moving : bool
var selected_tile : Tile

var command_window
var player_input

func _ready():
	turn = false
	command_window.connect("deselected",self,"on_deselected")
	command_window.connect("attack",self,"on_attack")
	command_window.connect("move",self,"on_move")
	is_attacking = false
	is_moving = false
func _process(delta):
	if(turn):
		if(Input.is_action_just_released("left_click")):
			if(selecting_target): # selecionar ação quando tiver unidade selecionada
				if(player_input.result.size() > 0):
					var tile = player_input.result.collider.get_parent()
					if(tile is Tile):
						if(is_attacking && !tile.is_tile_empty()):
							selected_tile.occupying_unit.attack(tile)
							after_move()
						elif(is_moving && tile.is_tile_empty()):
							selected_tile.occupying_unit.move(tile)
							selected_tile.remove_unit()
							after_move()
			else: # selecionar unidade para selecionar ação
				if(player_input.result.size() > 0):
					var tile = player_input.result.collider.get_parent()
					if(tile is Tile && !tile.is_tile_empty()):
						on_selected(tile)
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
	selected_tile.deselect()
	selected_tile = null
	command_window.visible = false
func on_attack():
	print("attack by " + selected_tile.occupying_unit.stats.name)
	selecting_target = true
	is_attacking = true
func on_move():
	print("move by " + selected_tile.occupying_unit.stats.name)
	selecting_target = true
	is_moving = true
func after_move():
	selecting_target = false
	is_attacking = false
	is_moving = false
	on_deselected()
