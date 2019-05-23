extends Spatial

export(String, FILE, "*.tscn, *.scn") var battle_path : String
var control_camera = true
func _ready():
	pass
func _process(delta):
	if (control_camera):
		CameraManager.processCameraMovement(delta)
func load_stage(stage : String):
	GameData.to_load = stage
	get_tree().change_scene(battle_path)
func _on_Button_button_up():
	GameData.save_game()


func _on_Button2_button_up():
	if(get_node("DebugWindow/Button2/TextEdit").text != ''):
		GameData.available_units.append(get_node("DebugWindow/Button2/TextEdit").text)


func _on_Button3_button_up():
	GameData.available_units.clear()
