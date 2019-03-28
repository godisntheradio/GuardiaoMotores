tool
extends LineEdit

var unit_list : ItemList

func _on_text_changed(new_text : String):
	if(unit_list.selected != null):
		if(get_parent().name == "Name"):
			unit_list.set_selected_name(text)
		else:
			unit_list.selected.set(get_parent().name.to_lower(), text.to_float())
	
func _on_item_selected():
	if(unit_list.selected != null):
		if(get_parent().name == "Name"):
			text = unit_list.selected.get(get_parent().name.to_lower())
		else:
			text = str(unit_list.selected.get(get_parent().name.to_lower()))
	
	
func _ready():
	unit_list = get_parent().get_parent().get_node("UnitList")
	connect("text_changed", self, "_on_text_changed")
	unit_list.select_connect(funcref(self, "_on_item_selected"))