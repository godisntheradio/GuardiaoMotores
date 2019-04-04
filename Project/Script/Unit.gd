extends Spatial
class_name Unit

var stats : Stats
#para criar unidades inimigas atraves do editor abilite editor creator e preencha os stats
export var editor_created : bool
export var ai_path : NodePath
export var hit_points : float
export var unit_name : String
export var attack : float
export var defense : float
export var magicAtk : float
export var magicDef : float
export var movement : int

export var movement_speed : float

export var hp : float

var is_attacking : bool
var is_moving : bool

var has_attacked : bool = false
var has_moved : bool = false
var start_pos : Vector2

var path : PoolVector3Array
var current_destination : Vector3
var current_index : int
var current_start : Vector3
var clock : float

var player : Player

func _ready():
	stats = Stats.new()
	if(editor_created):
		create_from_editor_stats()
		player = get_node(ai_path)
		player.units.append(self)
	current_index = 0
func _process(delta):
	if (is_moving):
		move_animation(delta)
func attack(pos : Tile):
#	pos.occupying_unit.hp += - stats.attack
	has_attacked = true
	pos.occupying_unit.death()
func move(pos : Tile, points : PoolVector3Array):
	has_moved = true
	path = points
	path.remove(0)
	update_destination()
	is_moving = true
	pos.occupying_unit = self
func undo_move(world_pos : Vector3):
	if has_moved:
		has_moved = false
		global_transform.origin = Vector3(world_pos.x, global_transform.origin.y, world_pos.z)

func take_damage():
	death()
	pass
func death():
	player.remove_unit(self)
	queue_free()
	pass
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
func create_from_editor_stats():
	stats.hit_points = hit_points 
	stats.name = unit_name
	stats.attack = attack
	stats.defense = defense
	stats.magicAtk = magicAtk
	stats.magicDef = magicDef 
	stats.movement = movement 
func reset():
	has_attacked = false
	has_moved = false