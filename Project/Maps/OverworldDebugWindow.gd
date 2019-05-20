extends Control

func _ready():
	pass # Replace with function body.
func _process(delta):
	if Input.is_action_just_released("open_debug_window"):
		visible = !visible