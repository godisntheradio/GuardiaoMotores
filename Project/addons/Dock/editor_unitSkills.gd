extends Label

var unit_list

func _ready():
	unit_list = get_parent().get_parent().get_node("UnitList")

