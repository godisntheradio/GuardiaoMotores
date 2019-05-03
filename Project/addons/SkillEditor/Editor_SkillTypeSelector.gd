extends Button

export var menu_path : NodePath
var menu : PopupMenu
signal value_changed


func _ready():
	menu = get_node(menu_path)

func set_value(string):
	pass
func get_value():
	pass

func _on_PopupMenu_id_pressed(ID):
	for i in range(menu.get_item_count()):
		menu.set_item_checked(i, false)
	
	menu.set_item_checked(ID, true)
	text = menu.get_item_text(ID)
	emit_signal("value_changed")