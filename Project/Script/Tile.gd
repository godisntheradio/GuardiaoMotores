extends Spatial
class_name Tile

export var terrain_type : int 
export var elevation : float
export var blocked : bool
export var starting_position : bool
export var unit : NodePath

var occupying_unit
var hover : bool
var selected : bool
var highlighted : bool

var display
var mesh_node

export var hover_color : Color
export var selected_color : Color
export var within_reach_color : Color
export var can_attack_color : Color
export var can_cure_color : Color
export var blocked_color : Color
export var aoe_color : Color

var map_coord : Vector2

func _ready():
	hover = false
	selected = false
	highlighted = false
	mesh_node = get_node("MeshInstance")
	display  = get_tree().get_root().get_node("Main/Control/UnitStatsDisplay")
	if(!unit.is_empty()):
		occupying_unit = get_node(unit)
	pass
	
func remove_unit(): #nao deve deletar a unidade da memoria
	if (!is_tile_empty()):
		occupying_unit = null
func is_tile_empty():
	if(occupying_unit != null):
		return false
	else:
		return true
		
func show_stats():
	display.visible = true
	display.set_unit_stats(occupying_unit)
	pass
func hide_stats():
	display.visible = false
	pass

func get_cost():
	return 1.0
func select():
	mesh_node.select()
func deselect():
	mesh_node.deselect()
func _on_RigidBody_mouse_exited():
	mesh_node.mouse_exited()
	if(!is_tile_empty()):
		hide_stats()
func _on_RigidBody_mouse_entered():
	if(!blocked):
		mesh_node.mouse_entered(hover_color)
	else:
		mesh_node.mouse_entered(blocked_color)
	if(!is_tile_empty()):
		show_stats()
		
func aoe_blink_enter():
	mesh_node.mouse_entered(aoe_color)
func aoe_blink_exit():
	mesh_node.mouse_exited()
	
func highlight_movable():
	mesh_node.start_highlight(within_reach_color)
func highlight_attackable():
	mesh_node.start_highlight(can_attack_color)
func highlight_curable():
	mesh_node.start_highlight(can_cure_color)
func stop_highlight():
	mesh_node.stop_highlight()