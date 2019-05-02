extends Spatial

export var battle_path : String

func _ready():
	get_node("Stage").connect("selected",self,"load_stage")
	pass
func load_stage(stage : String):
	GameData.to_load = stage
	get_tree().change_scene(battle_path)
func _on_Button_button_up():
	GameData.save_game()


func _on_Button2_button_up():
	if(get_node("Control/Button2/TextEdit").text != ''):
		GameData.available_units.append(get_node("Control/Button2/TextEdit").text)
