tool
extends ItemList

const FILE_PATH = "res://skills.txt"

class SkillData:
	var name : String
	var hp : float
	var attack : float
	var defense : float
	var magic_attack : float
	var magic_defense : float
	var movement : int

var skills : Array = []

var selectedCallbacks : Array = []

var selected : SkillData = null
var selectedIdx : int

func set_selected_name(n : String):
	selected.name = n
	if(n == "" || n == " "):
		set_item_text(selectedIdx, "Unnamed")
	else:
		set_item_text(selectedIdx, n)

func _on_select(index : int):
	selected = skills[index]
	selectedIdx = index
	for f in selectedCallbacks:
		f.call_func()

func deselect():
	selected = null
	selectedIdx = 0

func _ready():
	connect("item_selected", self, "_on_select")
	remove_item(0)
	load_from_file()
	
func select_connect(fRef : FuncRef):
	selectedCallbacks.append(fRef)

func _on_AddUnit_button_up():
	skills.append(SkillData.new())
	add_item("Unnamed")
	select(skills.size()-1)
	_on_select(skills.size()-1)


func _on_RemoveUnit_button_up():
	remove_item(selectedIdx)
	skills.remove(selectedIdx)
	if(skills.size() > 0):
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
	file.store_16(skills.size())
	print(skills.size())
	for u in skills:
		file.store_pascal_string(u.name)
		file.store_float(u.hp)
		file.store_float(u.attack)
		file.store_float(u.defense)
		file.store_float(u.magic_attack)
		file.store_float(u.magic_defense)
		file.store_16(u.movement)
		
func load_from_file():
	var file = File.new()
	if(!file.file_exists(FILE_PATH)): return
	file.open(FILE_PATH, file.READ)
	
	var unitCount = file.get_16()
	for i in range(unitCount):
		skills.append(SkillData.new())
		skills[i].name = file.get_pascal_string()
		skills[i].hp = file.get_float()
		skills[i].attack = file.get_float()
		skills[i].defense = file.get_float()
		skills[i].magic_attack = file.get_float()
		skills[i].magic_defense = file.get_float()
		skills[i].movement = file.get_16()
		add_item(skills[i].name)
	
func _on_SaveButton_button_up():
	save_to_file()