extends Spatial

export var camera_path : NodePath
var camera : Camera
export var camera_speed : float
var result
var dir : Vector3
var origin : Vector3

var allowed_to_cast : bool

func _ready():
	camera  = get_node(camera_path)
	allowed_to_cast = true
	result = null
	pass
func _process(delta):
	pass
func _physics_process(delta):
	processCameraMovement(delta)
	updateRay()
	pass
func updateRay():
	if(allowed_to_cast):
		var mouse = get_viewport().get_mouse_position()
		var space_state = get_world().direct_space_state
		dir = camera.project_ray_normal(mouse)
		origin = camera.project_ray_origin(mouse)
		result = space_state.intersect_ray(origin, origin + dir * 250 )
	else:
		result.clear()
	
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
		var cameraDir = get_node("KinematicBody").transform.basis.z.normalized()
		cameraDir.y = 0.0
		var move_result = get_node("KinematicBody").transform.basis.x.normalized() * move.x + cameraDir * move.z
		var kinematic = get_node("KinematicBody") as KinematicBody
		var motion = move_result * delta * camera_speed
		kinematic.move_and_collide(motion)
