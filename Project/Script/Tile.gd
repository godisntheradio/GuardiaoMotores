extends Spatial
class_name Tile

export var terrain_type : int 
export var elevation : float
export var blocked : bool
export var starting_position : bool

var occupying_unit
var hover : bool
var selected : bool
var highlighted : bool
var material_ref

var display
export var hover_color : Color
export var selected_color : Color
export var within_reach_color : Color

func _ready():
	hover = false
	selected = false
	highlighted = false
	material_ref = get_node("MeshInstance").get_surface_material(0)
	display  = get_tree().get_root().get_node("Main/Control/UnitStatsDisplay")
	pass
	
func remove_unit(): #nao deve deletar a unidade da memoria
	if (!is_tile_empty()):
		occupying_unit = null
		
func _on_RigidBody_mouse_exited():
	hover = false
	if(!selected):
		stop_blinking()
	elif(!highlighted):
		stop_highlight()
	else:
		start_blinking(selected_color)
	if(!is_tile_empty()):
		hide_stats()
func _on_RigidBody_mouse_entered():
	hover = true
	start_blinking(hover_color)
	if(!is_tile_empty()):
		show_stats()
		
func is_tile_empty():
	if(occupying_unit != null):
		return false
	else:
		return true
		
func start_blinking(color):
	material_ref.set_shader_param("blink_color",color)
	material_ref.set_shader_param("should_blink",true)
	pass
func stop_blinking():
	material_ref.set_shader_param("should_blink",false)
	pass
	
func show_stats():
	display.visible = true
	display.set_unit_stats(occupying_unit)
	pass
func hide_stats():
	display.visible = false
	pass
	
func select():
	selected = true
	start_blinking(selected_color)
func deselect():
	stop_blinking()
	selected = false
	
func highlight():
	highlighted = true
	material_ref.set_shader_param("tint_color",within_reach_color)
func stop_highlight():
	highlighted = false
	material_ref.set_shader_param("tint_color",Color(0,0,0,1))