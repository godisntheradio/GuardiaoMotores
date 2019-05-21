tool
extends Button

var unit_list

export var file_dialog_path : NodePath
var file_dialog : FileDialog

func _enter_tree():
	file_dialog = get_node(file_dialog_path)
	unit_list = get_parent().get_node("UnitList")
	unit_list.select_connect(funcref(self, "_on_item_selected"))

func _on_model_pressed():
	file_dialog.show()
	file_dialog.rect_global_position = rect_global_position
func _on_item_selected():
	text = unit_list.selected.model

func _on_model_dialog_file_selected(path):
	set_txt(path)
	unit_list.selected.model = text
func set_txt(txt):
	hint_tooltip = txt
	text = txt