extends Spatial
class_name BattleManager
var map : Map

export var player_list = []
var turn_count = 0
var has_started

var HumanPlayerScene = preload("res://Objects/PlayerHuman.tscn")
var AIPlayerScene = preload("res://Objects/PlayerAI.tscn")
var AStarManager = load("res://Script/AStarManager.gd")


var human_player
var astarManager


export var command_window : NodePath
export var turn_window : NodePath
func _ready():
	has_started = false
	var level_resource = load(GameData.to_load)
	var level = level_resource.instance()
	add_child(level)
func on_begin_battle(deployed_units):
	prepare_player()
	#init map
	map = get_child(0).get_node("Map")
	astarManager = AStarManager.new(map)
	
	#Init player
	player_list.append(human_player)
	human_player.units = deployed_units
	human_player.initialize_state_machine()
	for unit in human_player.units:
		unit.player = human_player
		unit.connect("action_finished", human_player, "on_unit_finished_action")
	#init AI
	var ai = get_child(0).get_node("AIPlayer")
	player_list.append(ai)
	for unit in ai.units:
		unit.player = ai
		unit.connect("action_finished", ai, "on_unit_finished_action")
	ai.battle_manager = self
	ai.camera_manager = CameraManager
	
	astarManager.update_connections()
	
	has_started = true
	
	player_list[turn_count % player_list.size()].begin_turn()
	
func on_end_player_turn():
	player_list[turn_count % player_list.size()].end_turn()
	turn_count += 1
	player_list[turn_count % player_list.size()].begin_turn()
	pass
func get_available_movement(unit : Unit):
	var mov = astarManager.get_available_movement(map.world_to_map(unit.global_transform.origin), unit.stats.movement)
	return mov.duplicate()
func get_available_attack(unit : Unit, skill_range : int = 1):
	var mov = astarManager.get_available_movement(map.world_to_map(unit.global_transform.origin), skill_range, true)
	return mov.duplicate()
func get_neighbors(tile :Tile, reach : int =1):
	var mov = astarManager.get_available_movement(map.world_to_map(tile.global_transform.origin), reach, true)
	return mov.duplicate()
func get_path_from_to(from : Tile, to : Tile):
	return astarManager.get_path(map.world_to_map(from.translation),map.world_to_map(to.translation))
	
func prepare_player():
	human_player = HumanPlayerScene.instance()
	human_player.command_window = get_node(command_window)
	human_player.camera_manager = CameraManager
	human_player.battle_manager = self
	human_player.turn_window = get_node(turn_window)
	add_child(human_player)

func get_enemy_units(player : Player):
	var res = []
	for p in player_list:
		if p != player:
			res = p.units.duplicate()
	return res