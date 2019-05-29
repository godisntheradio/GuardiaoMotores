extends Spatial

export(String, FILE, "*.tscn, *.scn") var battle_path : String
var control_camera = true
export var stages_path : NodePath
var stages : Array 
export var menu_path : NodePath
var menu 
func _ready():
	stages = get_node(stages_path).get_children()
	menu = get_node(menu_path)
func _process(delta):
	if (control_camera):
		CameraManager.processCameraMovement(delta)
	if (Input.is_action_just_released("open_overworld_menu")):
		menu.visible = true
func load_stage(stage : String):
	GameData.to_load = stage
	GameData.world_map_camera_pos = CameraManager.translation
	get_tree().change_scene(battle_path)
func _on_Button_button_up():
	GameData.save_game()


func _on_Button2_button_up():
	if(get_node("DebugWindow/Button2/TextEdit").text != ''):
		GameData.available_units.append(get_node("DebugWindow/Button2/TextEdit").text)


func _on_Button3_button_up():
	GameData.available_units.clear()
func refresh(): # update each stage according to save file
	pass 