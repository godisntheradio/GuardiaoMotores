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
func _on_RigidBody_mouse_entered():
	mesh_node.mouse_entered()
func highlight_movable():
	mesh_node.highlight_movable()
func highlight_attackable():
	mesh_node.highlight_attackable()
func stop_highlight():
	mesh_node.stop_highlight()