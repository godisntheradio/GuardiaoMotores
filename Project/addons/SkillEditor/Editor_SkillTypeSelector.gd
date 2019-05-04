tool
extends Button

export var menu_path : NodePath
var menu : PopupMenu
signal value_changed
var index

func _enter_tree():
	menu = get_node(menu_path)
	menu.connect("id_pressed",self,"_on_PopupMenu_id_pressed")

func set_value(id):
	if (id == -1):
		text = "<choose type>"
	else:
		text = menu.get_item_text(id)
		index = id
func get_value():
	return index

func _on_PopupMenu_id_pressed(ID):
	for i in range(menu.get_item_count()):
		menu.set_item_checked(i, false)
	
	menu.set_item_checked(ID, true)
	text = menu.get_item_text(ID)
	index = ID
	emit_signal("value_changed")

func _on_TypeButton_button_up():
	menu.rect_position = rect_global_position
	menu.show()