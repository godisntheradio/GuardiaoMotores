extends Spatial
class_name Stage
export(String, FILE, "*.tscn") var map_to_load : String
export var stage_name : String
export var difficulty : int
export(String, MULTILINE) var description : String
signal selected
signal selected_to_reforest
signal change_stage_state
export var locked_mat_ : Material
export var free_mat_ : Material
export var open_mat_ : Material

enum { LOCKED, OPEN, FREE, REFORESTED }
var state
var type_reforested

export(Array,int)var types_available : Array
export(Array,NodePath)var unlock_requirements_paths : Array
var unlock_requirements : Array
func _init():
	state = LOCKED
	type_reforested = -1
func _ready():
	unlock_requirements = []
	for i in unlock_requirements_paths:
		unlock_requirements.append(get_node(i))
	connect("selected",get_parent().get_parent().get_node("UI/StageDescWindow"),"show_desc")
	connect("selected_to_reforest",get_parent().get_parent().get_node("UI/ReforestMenu"),"open_window")
	connect("change_stage_state",get_parent().get_parent(), "save_stage_states")
	state = GameData.state_progress[stage_name]
	type_reforested = GameData.state_progress[stage_name+"_type_used"]
	load_stage_state()
func load_stage_state():
	match state:
		LOCKED:
			lock_stage()
		OPEN:
			unlock_stage()
		FREE:
			free_stage()
		REFORESTED:
			reforest(type_reforested)
func _on_RigidBody_input_event(camera, event, click_position, click_normal, shape_idx):
	if event is InputEventMouseButton && event.pressed && event.button_index == BUTTON_LEFT:
		if(state == OPEN):
			emit_signal("selected", self)
		elif(state == FREE):
			emit_signal("selected_to_reforest",self)
func lock_stage():
	get_node("Model/Stage").set_surface_material(0, locked_mat_)
	state = LOCKED
	emit_signal("change_stage_state")
func unlock_stage():
	get_node("Model/Stage").set_surface_material(0, open_mat_)
	state = OPEN
	emit_signal("change_stage_state")
func free_stage():
	get_node("Model/Stage").set_surface_material(0, free_mat_)
	state = FREE
	emit_signal("change_stage_state")
func reforest(type):
	get_node("Model/Stage").mesh = load("res://Models/cabin.obj")
	state = REFORESTED
	type_reforested = type
	emit_signal("change_stage_state")