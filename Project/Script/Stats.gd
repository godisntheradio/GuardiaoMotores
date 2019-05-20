extends Object
class_name Stats

export var hit_points : float
export var name : String
export var attack : float
export var defense : float
export var magicAtk : float
export var magicDef : float
export var movement : int
export var skills : Array
func _init():
	skills = []
func _ready():
	pass # Replace with function body.
func add(other : Stats):
	var result = get_script().new()
	result.attack = attack + other.attack
	result.defense = defense + other.defense
	result.magicAtk = magicAtk + other.magicAtk
	result.magicDef = magicDef + other.magicDef
	result.hit_points = hit_points + other.hit_points
	result.name = name
	result.movement = movement + other.movement
	return result