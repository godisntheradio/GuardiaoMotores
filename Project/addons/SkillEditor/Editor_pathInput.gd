tool
extends Button
signal value_changed

export var file_dialog_path : NodePath
var file_dialog : FileDialog

func _enter_tree():
	file_dialog = get_node(file_dialog_path)
func set_value(string):
	text = str(string)
func get_value():
	return text

func _on_Anim_pressed():
	file_dialog.show()
	file_dialog.rect_global_position = rect_global_position
func _on_AnimPath_file_selected(path):
	set_txt(path)
func set_txt(txt):
	hint_tooltip = txt
	text = txt
	emit_signal("value_changed")