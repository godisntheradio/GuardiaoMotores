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
	refresh_stages()
func _process(delta):
	if (control_camera):
		CameraManager.processCameraMovement(delta)
	if (Input.is_action_just_released("open_overworld_menu")):
		menu.visible = true
func load_stage(stage):
	GameData.stage_to_load = stage.map_to_load
	GameData.stage_name_to_load = stage.stage_name
	GameData.world_map_camera_pos = CameraManager.translation
	get_tree().change_scene(battle_path)
func _on_Button_button_up():
	GameData.save_game()


func _on_Button2_button_up():
	if(get_node("DebugWindow/Button2/TextEdit").text != ''):
		GameData.available_units.append(get_node("DebugWindow/Button2/TextEdit").text)


func _on_Button3_button_up():
	GameData.available_units.clear()
func get_stage_by_name(name):
	for s in stages:
		if(s.stage_name == name):
			return s
	return null
func save_stage_states():
	for s in stages:
		GameData.state_progress[s.stage_name] = s.state
		GameData.state_progress[s.stage_name+"_type_used"] = s.type_reforested
func refresh_stages(): # update each stage
	for s in stages:
		var count = 0
		for r in s.unlock_requirements:
			if(r.state == Stage.FREE || r.state == Stage.REFORESTED):
				count = count+1
		if(count == s.unlock_requirements.size() && s.state == Stage.LOCKED):
			s.unlock_stage()
	save_stage_states()
