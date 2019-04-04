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
export var turn_window : NodePath
func _ready():
	human_player = HumanPlayerScene.instance()
	prepare_player()
	map = get_node("Level1").get_child(0)
	astarManager = AStarManager.new(map)
	add_child(human_player)
func on_begin_battle(deployed_units):
	player_list.append(human_player)
	var ai = get_child(0).get_node("AIPlayer")
	player_list.append(ai)
	canControl = true
	human_player.units = deployed_units
	for unit in human_player.units:
		unit.player = human_player
	for unit in ai.units:
		unit.player = ai
	ai.battle_manager = self
	astarManager.update_connections()
	player_list[turn_count % player_list.size()].begin_turn()
	pass
func on_end_player_turn():
	player_list[turn_count % player_list.size()].end_turn()
	turn_count += 1
	player_list[turn_count % player_list.size()].begin_turn()
	pass
func get_available_movement(unit : Unit):
	var mov = astarManager.get_available_movement(map.world_to_map(unit.global_transform.origin), unit.stats.movement)
	return mov.duplicate()
func get_available_attack(unit : Unit):
	var mov = astarManager.get_available_movement(map.world_to_map(unit.global_transform.origin), 1, true)
	return mov.duplicate()
func get_path_from_to(from : Tile, to : Tile):
	return astarManager.get_path(map.world_to_map(from.translation),map.world_to_map(to.translation))
	
func prepare_player():
	human_player.command_window = get_node(command_window)
	human_player.player_input = get_node(player_input)
	human_player.battle_manager = self
	human_player.turn_window = get_node(turn_window)

func get_enemy_units(player : Player):
	var res = []
	for p in player_list:
		if p != player:
			res = p.units.duplicate()
	return res

