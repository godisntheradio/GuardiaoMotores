extends Control
var overworld_path = "res://Maps/Overworld.tscn"
var fade_wait
var to_execute : FuncRef

var load_list : ItemList
var selected_index : int
var valid_indexes : Array

func _ready():
	CameraManager.fade_in()
	to_execute = FuncRef.new()
	to_execute.set_instance(self)
	load_list = get_node("Load/LoadList")
	add_saves_to_list(load_list)
func _on_NewGame_pressed():
	CameraManager.fade_out()
	to_execute.set_function("start_new_game")
	fade_wait = true
func _on_Continue_pressed():
	open_load_list()

func _on_Credits_pressed():
	pass # Replace with function body.


func _on_Exit_pressed():
	pass # Replace with function body.
func _process(delta):
	if (fade_wait):
		if(CameraManager.is_fade_done()):
			to_execute.call_func()
func start_new_game():
	GameData.index_to_load = GameData.SAVE_BASE
	get_tree().change_scene(overworld_path)
func continue_game():
	GameData.index_to_load = selected_index
	GameData.init_game()
	get_tree().change_scene(overworld_path)
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
func _on_LoadList_item_selected(index):
	selected_index = index
	get_node("Load/LoadList/LoadConfirmation").show()
	get_node("Load/LoadList/LoadConfirmation").rect_position = Vector2(400,215)
func _on_LoadConfirmation_confirmed():
	close_menu()
	to_execute.set_function("continue_game")
	CameraManager.fade_out()
	fade_wait = true
func close_menu():
	load_list.get_parent().visible = false
func open_load_list():
	load_list.get_parent().visible = true