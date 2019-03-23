extends Spatial
class_name Tile

var terrain_type
var elevation
var blocked
var pos

var hover : bool
var material_ref

func _ready():
	hover = false
	material_ref = get_node("MeshInstance").get_surface_material(0)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_RigidBody_mouse_exited():
	hover = false
	stop_blinking()
	pass # Replace with function body.
func _on_RigidBody_mouse_entered():
	hover = true
	start_blinking()
	pass # Replace with function body.
	
	

func start_blinking():
	material_ref.set_shader_param("should_blink",true)
	pass
func stop_blinking():
	material_ref.set_shader_param("should_blink",false)
	pass
