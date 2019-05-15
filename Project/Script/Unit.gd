extends Spatial
class_name Unit

export var hp : float
var stats : Stats
var modifiers_stack : Array = []
#para criar unidades inimigas atraves do editor habilite editor_created e preecha to_search com o nome da unidade criada no editor de unidades
export var editor_created : bool
export var ai_path : NodePath
export var to_search : String


#estado do turno, só pode atacar e se movimentar uma vez por turno
var has_attacked : bool = false
var has_moved : bool = false

#animação do movimento
var is_attacking : bool
var is_moving : bool
var start_pos : Vector2
var path : PoolVector3Array
var current_destination : Vector3
var current_index : int
var current_start : Vector3
var clock : float
#velocidade da animação de movimento
export var movement_speed : float

var player : Player

var skills  : Array = []
signal action_finished

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
	pos.occupying_unit = null
	emit_signal("action_finished")
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

func take_damage(dmg : int):
	death()
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
			emit_signal("action_finished")
			current_index = 0
func create_from_editor_stats():
	#procura pelo nome na lista de todas as unidades no GameData e carrega
	pass 
func reset():
	has_attacked = false
	has_moved = false