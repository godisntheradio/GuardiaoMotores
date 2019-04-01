extends Spatial

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
	map = get_node("../Map")
	astarManager = AStarManager.new(map)
	add_child(human_player)
func on_begin_battle():
	player_list.append(human_player)
	player_list[turn_count % player_list.size()].begin_turn()
	pass
func on_end_player_turn():
	turn_count += 1
	pass
	
func _input(event):
	if(canControl):
		if event is InputEventMouseButton:
			if(human_player.player_input.result.size() > 0):
				var t : Tile = human_player.player_input.result.collider.get_parent()
				if(t.occupying_unit != null):
					var mov = astarManager.get_available_movement(map.world_to_map(t.translation), 3)
					for m in mov:
						var tile : Tile = map.get_tile(Vector2(m.x, m.y))
						tile.start_blinking(Color(1,0,1))

func _on_DeployUnitsWindow_tree_exited():
	canControl = true
