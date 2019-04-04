extends Control
export var battle_manager_path : NodePath
var battle_manager : BattleManager
func _ready():
	battle_manager = get_node(battle_manager_path)
	get_node("Button").connect("button_up",battle_manager,"on_end_player_turn")