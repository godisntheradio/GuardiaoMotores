extends Spatial
export var to_load : String

signal selected
func _ready():
	pass 


func _on_RigidBody_input_event(camera, event, click_position, click_normal, shape_idx):
	if event is InputEventMouseButton && !event.pressed && event.button_index == BUTTON_LEFT:
		emit_signal("selected", to_load)
	pass # Replace with function body.
