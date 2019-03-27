extends Spatial
class_name Tile

export var terrain_type : int 
export var elevation : float
export var blocked : bool
export var pos : Vector3

var occupying_unit
var hover : bool
var material_ref

var display
func _ready():
	pos = translation + Vector3(0,2.0,0)
	hover = false
	material_ref = get_node("MeshInstance").get_surface_material(0)
	display  = get_tree().get_root().get_node("Main/Control/UnitStatsDisplay")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_RigidBody_mouse_exited():
	hover = false
	stop_blinking()
	if(occupying_unit != null):
		hide_stats()
	pass # Replace with function body.
func _on_RigidBody_mouse_entered():
	hover = true
	start_blinking()
	if(occupying_unit != null):
		show_stats()
	pass # Replace with function body.
	
	

func start_blinking():
	material_ref.set_shader_param("should_blink",true)
	pass
func stop_blinking():
	material_ref.set_shader_param("should_blink",false)
	pass
func show_stats():
	display.visible = true
	display.set_unit_stats(occupying_unit)
	pass
func hide_stats():
	display.visible = false
	pass