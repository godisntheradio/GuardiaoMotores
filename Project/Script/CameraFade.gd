extends Panel

var opaque = Color(0, 0, 0, 1)
var transparent = Color(0, 0, 0, 0)
var current_colour = opaque

var lerp_start = opaque
var lerp_end = transparent
var current_lerp = 0

var fade_done = true
var fade_time = 1 #seconds

func _ready():
	pass

func _process(delta):
	if(!fade_done):
		current_lerp += delta / fade_time
		current_colour = lerp(lerp_start, lerp_end, current_lerp)
		get_stylebox("panel", "").bg_color = current_colour
		if(current_lerp >= 1):
			fade_done = true

func fade_out():
	fade_done = false
	lerp_start = current_colour
	lerp_end = opaque
	current_lerp = current_colour.a
	
func fade_in():
	fade_done = false
	lerp_start = current_colour
	lerp_end = transparent
	current_lerp = 1 - (current_colour.a)
