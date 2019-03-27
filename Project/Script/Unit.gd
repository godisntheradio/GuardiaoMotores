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
func attack(pos : Vector2):
	pass
func move(pos : Vector2):
	pass
