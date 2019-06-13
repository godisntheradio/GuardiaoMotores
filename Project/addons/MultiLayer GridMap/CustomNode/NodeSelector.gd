extends Node

static func select_single(node : Node):
	var sel = EditorPlugin.new().get_editor_interface().get_selection()
	sel.clear()
	sel.add_node(node)