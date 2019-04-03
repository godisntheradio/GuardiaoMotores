extends Spatial
class_name Unit

var stats : Stats
#para criar unidades inimigas atraves do editor abilite editor creator e preencha os stats
export var editor_created : bool
export var hit_points : float
export var unit_name : String
export var attack : float
export var defense : float
export var magicAtk : float
export var magicDef : float
export var movement : int

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
	if(editor_created):
		create_from_editor_stats()
	current_index = 0
func _process(delta):
	if (is_moving):
		move_animation(delta)
func attack(pos : Tile):
	pos.occupying_unit.hp += - stats.attack
func move(pos : Tile, points : PoolVector3Array):
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
func create_from_editor_stats():
	stats.hit_points = hit_points 
	stats.name = unit_name
	stats.attack = attack
	stats.defense = defense
	stats.magicAtk = magicAtk
	stats.magicDef = magicDef 
	stats.movement = movement 