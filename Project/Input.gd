extends Spatial
export var camera_path : NodePath
var camera : Camera
# Called when the node enters the scene tree for the first time.
func _ready():
	camera  = get_node(camera_path)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var mouse = get_viewport().get_mouse_position()
	var space_state = get_world().direct_space_state
	var result = space_state.intersect_ray(translation, camera.project_ray_normal(mouse))
	if(result):
		print(result.position + " " + result.collider.get_name())
