extends Spatial
class_name BattleManager
var map : Map

export var player_list = []
var turn_count = 0

var HumanPlayerScene = preload("res://Objects/PlayerHuman.tscn")
var AIPlayerScene = preload("res://Objects/PlayerAI.tscn")
var AStarManager = load("res://Script/AStarManager.gd")


var human_player
var astarManager

export var command_window : NodePath
export var turn_window : NodePath
func _ready():
	var level_resource = load(GameData.to_load)
	var level = level_resource.instance()
	add_child(level)
	pass
func on_begin_battle(deployed_units):
	prepare_player()
	
	map = get_child(0).get_node("Map")
	astarManager = AStarManager.new(map)
	
	var ai = get_child(0).get_node("AIPlayer")
	
	player_list.append(human_player)
	player_list.append(ai)
	human_player.units = deployed_units
	human_player.initialize_state_machine()
	for unit in human_player.units:
		unit.player = human_player
		unit.connect("action_finished", human_player, "on_unit_finished_action")
		
	for unit in ai.units:
		unit.player = ai
		unit.connect("action_finished", ai, "on_unit_finished_action")
	ai.battle_manager = self
	ai.camera_manager = CameraManager
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

