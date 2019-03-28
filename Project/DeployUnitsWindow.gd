extends Control
onready var item_list = get_node("Panel/ItemList")
func _ready():
	item_list.connect("item_selected",get_tree().get_root().get_node("Main/BattleManager"),"_on_selected_from_list")
	
	item_list.set_same_column_width(true)
	item_list.set_max_text_lines(50)
	item_list.set_auto_height(true)
	for unit in PlayerData.available_units:
		item_list.add_item(unit.name + "   ")