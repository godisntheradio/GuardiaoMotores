tool
extends LineEdit
signal value_changed
var unit_list : ItemList

func _on_text_changed(new_text : String):
	unit_list.set_selected_name(text)
	emit_signal("value_changed")
func set_value(string):
	text = string
func get_value():
	return text
func _ready():
	unit_list = get_parent().get_parent().get_node("SkillList")
	connect("text_changed", self, "_on_text_changed")