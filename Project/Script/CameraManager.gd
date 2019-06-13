extends KinematicBody

export var camera_path : NodePath
var camera : Camera
export var camera_speed : float
var result
var dir : Vector3
var origin : Vector3
var cursor : Vector3
var allowed_to_cast : bool

var fade_panel = null

export var labelref :NodePath
var label
func _ready():
	fade_panel = get_node("CanvasLayer/Panel")
	camera  = get_node(camera_path)
	label = get_node(labelref)
	allowed_to_cast = true
	result = null
	pass
func _process(delta):
	var minutes = GameData.playtime / 60
	var hours = minutes / 60.0
	add_to_debug(str(int(hours)) + ":"+str(int(minutes)))
func _physics_process(delta):
	updateCamera(cursor)
	updateRay()
	pass
func updateRay():
	if(allowed_to_cast):
		var mouse = get_viewport().get_mouse_position()
		var space_state = get_world().direct_space_state
		dir = camera.project_ray_normal(mouse)
		origin = camera.project_ray_origin(mouse)
		result = space_state.intersect_ray(origin, origin + dir * 250,[], 1)
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
		var cameraDir = camera.transform.basis.z.normalized()
		cameraDir.y = 0.0
		var move_result = camera.transform.basis.x.normalized() * move.x + cameraDir * move.z
		var motion = move_result * delta * camera_speed
		cursor = motion
func updateCamera(target : Vector3):
	move_and_slide(target)
	label.text = str( translation)
	cursor = Vector3.ZERO
func relocate(pos : Vector3):
	global_translate(pos - global_transform.origin)
func add_to_debug(s : String):
	label.text = label.text + "\n "+str(s)
	
func fade_out():
	fade_panel.fade_out()
func fade_in():
	fade_panel.fade_in()
func is_fade_done() -> bool:
	return fade_panel.fade_done