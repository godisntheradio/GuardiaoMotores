extends Spatial
class_name Unit
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var stats : Stats
export var movement_speed : float

export var tilePos : Vector2
export var hp : float

var is_attacking : bool
var is_moving : bool

var path : PoolVector3Array
var current_destination : Vector3
var current_index : int
var current_start : Vector3
var clock : float

func _ready():
	stats = Stats.new()
	current_index = 0
func _process(delta):
	if (is_moving):
		move_animation(delta)
func attack(pos : Tile):
	pos.occupying_unit.hp += - stats.attack
func move(pos : Tile, points : PoolVector3Array):
#	global_transform.origin = pos.global_transform.origin  + Vector3(0,2.0,0)
	path = points
	path.remove(0)
	update_destination()
	is_moving = true
	pos.occupying_unit = self
	
func update_destination():
	clock = 0
	current_destination = path[current_index] + Vector3(0,2.0,0)
	current_start = translation
func move_animation(delta):
	clock += delta * movement_speed
	if(clock <= 1):
		translation = lerp(current_start, current_destination, clock)
	else:
		if(current_index < path.size() - 1):
			current_index += 1
			update_destination()
		else:
			translation = path[current_index] + Vector3(0, 2.0, 0)
			is_moving = false
			current_index = 0