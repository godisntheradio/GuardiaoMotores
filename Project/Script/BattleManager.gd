extends Spatial

var map

export var player_list = []
var turn_count = 0

var HumanPlayerScene = preload("res://Objects/HumanPlayer.tscn")
var AIPlayerScene = preload("res://Objects/AIPlayer.tscn")

var human_player

export var command_window : NodePath
export var player_input : NodePath

func _ready():
	human_player = HumanPlayerScene.instance()
	human_player.command_window = get_node(command_window)
	human_player.player_input = get_node(player_input)
	add_child(human_player)
func on_begin_battle():
	player_list.append(human_player)
	player_list[turn_count % player_list.size()].begin_turn()
	pass
func on_end_player_turn():
	turn_count += 1
	pass