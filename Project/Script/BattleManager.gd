extends Spatial
class_name BattleManager
var map : Map

export var player_list = []
var turn_count = 0

var HumanPlayerScene = preload("res://Objects/HumanPlayer.tscn")
var AIPlayerScene = preload("res://Objects/AIPlayer.tscn")
var AStarManager = load("res://Script/AStarManager.gd")

var human_player
var astarManager
var canControl : bool = false

export var command_window : NodePath
export var player_input : NodePath

func _ready():
	human_player = HumanPlayerScene.instance()
	human_player.command_window = get_node(command_window)
	human_player.player_input = get_node(player_input)
	human_player.battle_manager = self
	map = get_node("../Map")
	astarManager = AStarManager.new(map)
	add_child(human_player)
func on_begin_battle(deployed_units):
	player_list.append(human_player)
	canControl = true
	human_player.units_in_battle = deployed_units
	player_list[turn_count % player_list.size()].begin_turn()
	pass
func on_end_player_turn():
	turn_count += 1
	pass
func get_available_movement(tile : Tile):
	var mov = astarManager.get_available_movement(map.world_to_map(tile.translation), tile.occupying_unit.stats.movement)
	return mov.duplicate()
func get_available_attack(tile : Tile):
	var mov = astarManager.get_available_movement(map.world_to_map(tile.translation), 1)
	return mov.duplicate()
func get_path_from_to(from : Tile, to : Tile):
	return astarManager.get_path(map.world_to_map(from.translation),map.world_to_map(to.translation))