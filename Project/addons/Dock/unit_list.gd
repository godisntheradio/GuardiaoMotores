tool
extends ItemList

const FILE_PATH = "res://units.txt"



var units : Array = []

var selectedCallbacks : Array = []

var GameDataLoader = preload("res://Script/GameDataLoader.gd")

var selected #: GameDataLoader.UnitData = null
var selectedIdx : int

func set_selected_name(n : String):
	selected.name = n
	if(n == "" || n == " "):
		set_item_text(selectedIdx, "Unnamed")
	else:
		set_item_text(selectedIdx, n)

func _on_select(index : int):
	selected = units[index]
	selectedIdx = index
	for f in selectedCallbacks:
		f.call_func()

func deselect():
	selected = null
	selectedIdx = 0

func _enter_tree():
	connect("item_selected", self, "_on_select")
	clear()
	load_from_file()
	select(0)
	_on_select(0)
func select_connect(fRef : FuncRef):
	selectedCallbacks.append(fRef)

func _on_AddUnit_button_up():
	units.append(GameDataLoader.UnitData.new())
	add_item("Unnamed")
	select(units.size()-1)
	_on_select(units.size()-1)


func _on_RemoveUnit_button_up():
	remove_item(selectedIdx)
	units.remove(selectedIdx)
	if(units.size() > 0):
		if(selectedIdx > 0):
			_on_select(selectedIdx-1)
			select(selectedIdx)
		else:
			_on_select(0)
			select(0)
	else:
		deselect()
		
func save_to_file():
	var file = File.new()
	file.open(FILE_PATH, file.WRITE)
	file.store_16(units.size())
	
	for u in units:
		file.store_pascal_string(u.name)
		file.store_float(u.hp)
		file.store_float(u.attack)
		file.store_float(u.defense)
		file.store_float(u.magic_attack)
		file.store_float(u.magic_defense)
		file.store_16(u.movement)
		file.store_pascal_string(u.model)
		file.store_16(u.skill_list.size())
		for skill in u.skill_list:
			file.store_pascal_string(skill.name)
			file.store_16(skill.type)
			file.store_16(skill.range_type)
			file.store_float(skill.effect)
			file.store_16(skill.reach) 
			file.store_16(skill.ignore)
			file.store_16(skill.aoe) 
			file.store_pascal_string(skill.anim)
		
func load_from_file():
	var file = File.new()
	if(!file.file_exists(FILE_PATH)): return
	file.open(FILE_PATH, file.READ)
	
	units = GameDataLoader.LoadUnitList(file)
	for unit in units:
		add_item(unit.name)
	
func _on_SaveButton_button_up():
	save_to_file()