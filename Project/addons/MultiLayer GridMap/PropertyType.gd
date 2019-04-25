tool
extends Button

signal _on_PropertyType_changed(new_type)

export var menu_path : NodePath
var menu : PopupMenu

func _enter_tree():
	menu = get_node(menu_path)
	menu.connect("id_pressed", self, "_on_TypeMenu_id_pressed")

func _on_PropertyType_button_down():
	menu.rect_position = rect_global_position
	menu.show()
	
func _on_TypeMenu_id_pressed(idx):
	print(menu.get_item_text(idx))
	
	for i in range(menu.get_item_count()):
		menu.set_item_checked(i, false)
	
	menu.set_item_checked(idx, true)
