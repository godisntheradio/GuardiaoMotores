tool
extends EditorPlugin

var dock
func _enter_tree():
	connect("scene_changed",self,"on_scene_change")
	dock = preload("res://addons/CreateTileTerrain/MakeGameTerrain.tscn").instance()
	add_control_to_dock(DOCK_SLOT_LEFT_UL, dock)
	
func _exit_tree():
	remove_control_from_docks(dock)
	
func on_scene_change(node : Node):
	pass