extends Spatial
class_name Stage
export var to_load : String
export var stage_name : String
export var difficulty : int
export(String, MULTILINE) var description : String
signal selected
func _ready():
	pass 


func _on_RigidBody_input_event(camera, event, click_position, click_normal, shape_idx):
	if event is InputEventMouseButton && !event.pressed && event.button_index == BUTTON_LEFT:
		emit_signal("selected", to_load)
	pass # Replace with function body.
