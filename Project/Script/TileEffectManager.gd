extends MeshInstance

var material_ref

var hover : bool
var selected : bool
var highlighted : bool



func _ready():
	hover = false
	selected = false
	highlighted = false
	material_ref = get_surface_material(0)
	pass
	
func mouse_entered(color):
	hover = true
	start_blinking(color)
func mouse_exited():
	hover = false
	if(!selected):
		stop_blinking()
	elif(!highlighted):
		stop_highlight()
	else:
		start_blinking(get_parent().selected_color)
func start_blinking(color):
	material_ref.set_shader_param("blink_color",color)
	material_ref.set_shader_param("should_blink",true)
	pass
func stop_blinking():
	material_ref.set_shader_param("should_blink",false)
	pass

func select():
	selected = true
	start_blinking(get_parent().selected_color)
func deselect():
	stop_blinking()
	selected = false
	
func start_highlight(color):
	highlighted = true
	material_ref.set_shader_param("tint_color",color)
func stop_highlight():
	highlighted = false
	material_ref.set_shader_param("tint_color",Color(0,0,0,1))
	