tool
extends EditorPlugin

var dock

func _enter_tree():
	dock = preload("res://addons/MultiLayer GridMap/Dock/Dock.tscn").instance()
	add_custom_type("MultiLayer GridMap", "Spatial", preload("res://addons/MultiLayer GridMap/CustomNode/Multilayer_GridMap.gd"), preload("res://addons/MultiLayer GridMap/CustomNode/icon.png"))
	add_control_to_dock(DOCK_SLOT_LEFT_UL, dock)

func _exit_tree():
	remove_control_from_docks(dock)
	remove_custom_type("MultiLayer GridMap")
