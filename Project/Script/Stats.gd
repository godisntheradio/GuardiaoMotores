extends Object
class_name Stats
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var hit_points : float
var attack : float
var defense : float
var magicAtk : float
var magicDef : float
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func add(other : Stats):
	var result = get_script().new()
	result.attack = attack + other.attack
	result.defense = defense + other.defense
	result.magicAtk = magicAtk + other.magicAtk
	result.magicDef = magicDef + other.magicDef
	result.hit_points = hit_points + other.hit_points
	return result