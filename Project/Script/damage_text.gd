extends RigidBody2D

var label : Label = null
var force : float = 100

var start = false
var set_visible = false
var pos : Vector2 = Vector2.ZERO

func begin(dmg : int, pos : Vector2):
	label.text = str(dmg)
	self.pos = pos
	start = true

func _integrate_forces(state):
	if(set_visible):
		visible = true
		set_visible = false
	if(start):
		var t = state.transform
		t.origin = pos
		state.transform = t
		start = false
		state.linear_velocity = Vector2.ZERO
		apply_impulse(Vector2(0, 0), Vector2(rand_range(-10, 10), -2).normalized() * force)
		gravity_scale = 5
		set_visible = true

func _ready():
	label = get_node("Label")

func _process(delta):
	if(position.y > get_viewport().size.y):
		queue_free()
func set_color(c : Color):
	label.add_color_override("font_color",c)