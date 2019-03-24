extends Spatial
var camera : Camera
export var camera_speed : float
func _ready():
	camera  = get_node("Camera")

	pass
func _process(delta):
	processCameraMovement(delta)
	pass
func _physics_process(delta):
	updateRay()
	pass
func updateRay():
	var mouse = get_viewport().get_mouse_position()
	var space_state = get_world().direct_space_state
	var dir = camera.project_ray_normal(mouse)
	var origin = camera.project_ray_origin(mouse)
	var result = space_state.intersect_ray(origin, origin + dir * 250 )
	
func processCameraMovement(delta):
	var move : Vector3
	if Input.is_action_pressed("move_camera_right"):
		move.x = 1.0
	if Input.is_action_pressed("move_camera_left"):
		move.x = -1.0
	if Input.is_action_pressed("move_camera_front"):
		move.z = -1.0
	if Input.is_action_pressed("move_camera_back"):
		move.z = 1.0
	if(move != Vector3.ZERO):
		var cameraDir = camera.transform.basis.z.normalized()
		cameraDir.y = 0.0
		var result = camera.transform.basis.x.normalized() * move.x + cameraDir * move.z
		translate(result * delta * camera_speed)
	
