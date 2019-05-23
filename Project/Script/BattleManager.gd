extends Spatial
class_name BattleManager
var map : Map

export var player_list = []
var turn_count = 0
var has_started

var HumanPlayerScene = preload("res://Objects/PlayerHuman.tscn")
var AIPlayerScene = preload("res://Objects/PlayerAI.tscn")
var AStarManager = load("res://Script/AStarManager.gd")

var GameDataLoader = preload("res://Script/GameDataLoader.gd")

var human_player
var astarManager

var debug : Label

var winner = -1

export var command_window : NodePath
export var turn_window : NodePath
func _ready():
	debug = get_node("Label")
	has_started = false
	var level_resource = load(GameData.to_load)
	var level = level_resource.instance()
	add_child(level)
	#init AI
	var ai = get_child(1).get_node("AIPlayer")
	player_list.append(ai)
	for unit in ai.units:
		unit.player = ai
		unit.connect("action_finished", ai, "on_unit_finished_action")
		if(unit.to_search != ""):
			unit.stats = GameDataLoader.create_unit(GameData.find_unit(unit.to_search))
		else:
			print("couldn't create '"+ unit.to_search +"' unit. name not has not been set properly")
		unit.hp = unit.stats.hit_points
	ai.battle_manager = self
	ai.camera_manager = CameraManager
	ai.initialize_state_machine()
func on_begin_battle(deployed_units):
	prepare_player()
	#init map
	map = get_child(1).get_node("Map")
	astarManager = AStarManager.new(map)
	
	#Init player
	player_list.push_front(human_player)
	human_player.units = deployed_units
	human_player.initialize_state_machine()
	for unit in human_player.units:
		unit.player = human_player
		unit.connect("action_finished", human_player, "on_unit_finished_action")
	
	
	astarManager.update_connections()
	
	has_started = true
	
	player_list[turn_count % player_list.size()].begin_turn()
	
func on_end_player_turn():
	player_list[turn_count % player_list.size()].end_turn()
	turn_count += 1
	player_list[turn_count % player_list.size()].begin_turn()
func get_available_movement(unit : Unit):
	debug.text = ""
	var from = map.world_to_map(unit.global_transform.origin)
	var mov = astarManager.get_available_movement(map.world_to_map(unit.global_transform.origin), unit.stats.movement)
	var r = mov.duplicate()
	debug.text += str(from)
	for pos in r:
		debug.text += "/n" + str(pos)
	return r
func get_available_attack(unit : Unit, skill_range : int = 1):
	var mov = astarManager.get_available_movement(map.world_to_map(unit.global_transform.origin), skill_range, true)
	return mov.duplicate()
func get_neighbors(tile :Tile, reach : int =1):
	var mov = astarManager.get_available_movement(map.world_to_map(tile.global_transform.origin), reach, true)
	var tiles = []
	for point in mov:
		var t : Tile = map.get_tile(Vector2(point.x, point.y))
		tiles.append(t)
	return tiles.duplicate()
func get_path_from_to(from : Tile, to : Tile):
	var vecfrom = map.world_to_map(from.global_transform.origin)
	var vecto = map.world_to_map(to.global_transform.origin)
	return astarManager.get_path(vecfrom,vecto)
func get_tile_from_unit(unit:Unit) -> Tile:
	return map.get_tile(map.world_to_map(unit.global_transform.origin))
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

func check_game_over():
	for p in range(player_list.size()):
		if (player_list[p].units.size() == 0):
			winner = p
	if (winner >= 0):
		get_node("../Control/GameOver").visible = true

func _on_GameOverBack_pressed():
	get_tree().change_scene("res://Maps/Overworld.tscn")