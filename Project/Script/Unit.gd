extends Spatial
class_name Unit
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var stats : Stats
export var tilePos : Vector2
export var hp : float
# Called when the node enters the scene tree for the first time.
func _ready():
	stats = Stats.new()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func attack(pos : Tile):
	pos.occupying_unit.hp += - stats.attack
func move(pos : Tile):
	global_transform.origin = pos.global_transform.origin  + Vector3(0,2.0,0)
	pos.occupying_unit = self
