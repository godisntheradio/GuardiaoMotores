extends MeshInstance

var material_ref

var hover : bool
var selected : bool
var highlighted : bool

export var color : Color

func _ready():
	hover = false
	selected = false
	highlighted = false
	material_ref = get_surface_material(0)
	pass
	
func mouse_entered():
	hover = true
	start_blinking(get_parent().hover_color)
	if(!get_parent().is_tile_empty()):
		get_parent().show_stats()
func mouse_exited():
	hover = false
	if(!selected):
		stop_blinking()
	elif(!highlighted):
		stop_highlight()
	else:
		start_blinking(get_parent().selected_color)
	if(!get_parent().is_tile_empty()):
		get_parent().hide_stats()
		
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
	
func highlight_movable():
	highlighted = true
	material_ref.set_shader_param("tint_color",get_parent().within_reach_color)
func highlight_attackable():
	highlighted = true
	material_ref.set_shader_param("tint_color",get_parent().can_attack_color)
func stop_highlight():
	highlighted = false
	material_ref.set_shader_param("tint_color",Color(0,0,0,1))
	