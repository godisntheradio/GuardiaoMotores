extends Control


var save_list : ItemList
var load_list : ItemList
var selected_index : int
var valid_indexes : Array
func _ready():
	save_list = get_node("Save/SaveList")
	load_list = get_node("Load/LoadList")
	selected_index = -1
	valid_indexes = []
func _process(delta):
	if(Input.is_action_just_released("ui_cancel") && visible):
		close_menu()
func _on_SaveList_item_selected(index):
	selected_index = index
	if(valid_indexes.find(selected_index) != -1):
		get_node("Save/SaveList/SaveConfirmation").show()
		get_node("Save/SaveList/SaveConfirmation").rect_position = Vector2(400,215)
	else:
		_on_SaveConfirmation_confirmed()
func _on_LoadList_item_selected(index):
	selected_index = index
	get_node("Load/LoadList/LoadConfirmation").show()
	get_node("Load/LoadList/LoadConfirmation").rect_position = Vector2(400,215)
func _on_SaveConfirmation_confirmed():
	get_parent().get_parent().refresh_stages()
	GameData.save_game(selected_index)
	close_menu()
func _on_LoadConfirmation_confirmed():
	close_menu()
	GameData.index_to_load = selected_index
	get_tree().reload_current_scene()
	GameData.init_game()
	
func add_saves_to_list(list : ItemList):
	list.clear()
	for i in range(5):
		var save = GameData.load_game(i)
		if(save != null):
			var date = save.data[GameData.DATE_KEY]
			var minutes = save.data[GameData.PLAYTIME_KEY] / 60
			var hours = minutes / 60.0
			list.add_item(str(date["day"])+ "/"+str(date["month"])+"/"+str(date["year"]) + "                        " + str(int(hours)) + ":"+str(int(minutes)))
			valid_indexes.append(i)
		else:
			list.add_item("Empty Slot")
func _on_SaveButton_pressed():
	open_save_list()
	add_saves_to_list(save_list)
func _on_LoadButton_pressed():
	open_load_list()
	add_saves_to_list(load_list)
func _on_ExitButton_pressed():
	pass
func close_menu():
	visible = false
	load_list.get_parent().visible = false
	save_list.get_parent().visible = false
func _on_CloseButton_pressed():
	close_menu()
func open_save_list():
	save_list.get_parent().visible = true
func open_load_list():
	load_list.get_parent().visible = true
