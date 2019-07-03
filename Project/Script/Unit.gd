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

var dmg_number = preload("res://Objects/UI/DamageText.tscn")
var positive_color = Color(0.1,1.0,0,1.0)
func _ready():
	stats = Stats.new()
	if(editor_created):
		player = get_node(ai_path)
		player.units.append(self)
	current_index = 0
	if($Model):
		$Model.play_idle()
		
func _process(delta):
	if (is_moving):
		move_animation(delta)
func attack(pos : Tile, skill : Skill):
	pos.occupying_unit.take_damage(skill.calculate_effect(stats, pos.occupying_unit.stats))
	has_attacked = true
	if(!$Model):
		emit_signal("action_finished")
	else:
		$Model.play_attack(skill.name)
func move(pos : Tile, points : PoolVector3Array):
	has_moved = true
	path = points
	path.remove(0)
	update_destination()
	is_moving = true
	pos.occupying_unit = self
	if($Model):
		$Model.play_run()
func do_nothing():
	emit_signal("action_finished")
func undo_move(world_pos : Vector3):
	if has_moved:
		has_moved = false
		global_transform.origin = Vector3(world_pos.x, global_transform.origin.y, world_pos.z)

func take_damage(dmg : int):
	hp += dmg
	var txt_pos = CameraManager.camera.unproject_position(global_transform.origin + Vector3(0, 1, 0))
	var dmg_txt = dmg_number.instance()
	get_tree().root.add_child(dmg_txt)
	if(dmg > 0):
		dmg_txt.set_color(positive_color)
	dmg_txt.begin(dmg, txt_pos)
	if (hp < 1):
		death()
	elif(hp > stats.hit_points):
		hp = stats.hit_points
func death():
	player.remove_unit(self)
	queue_free()
	pass
func update_destination():
	clock = 0
	if (path.size() == 0):
		return
	current_destination =path[current_index] + Vector3(0,2.0,0)
	current_start = global_transform.origin
func move_animation(delta):
	clock += delta * movement_speed
	if(clock <= 1):
		global_transform.origin = lerp(current_start, current_destination, clock)
		look_at(current_destination,Vector3.UP)
	else:
		if(current_index < path.size() - 1):
			current_index += 1
			update_destination()
		else:
			global_transform.origin = path[current_index] + Vector3(0, 2.0, 0)
			is_moving = false
			emit_signal("action_finished")
			if($Model):
				$Model.play_idle()
			current_index = 0
func reset():
	has_attacked = false
	has_moved = false
func add_skill_anims():
	if($Model):
		for s in stats.skills:
			$Model.animator.add_animation(s.name,s.anim)