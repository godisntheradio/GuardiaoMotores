tool
extends ItemList

const FILE_PATH = "res://skills.txt"
class SkillData:
	var name : String
	var type : int
	var effect : float
	var reach : int
	var aoe : int
	var anim : String

var skills : Array = []

var selected : SkillData = null
var selectedIdx : int

export var name_path : NodePath
export var type_path : NodePath
export var effect_path : NodePath
export var reach_path : NodePath
export var aoe_path : NodePath
export var anim_path : NodePath

var name_node
var type_node
var effect_node
var reach_node
var aoe_node
var anim_node

func _ready():
	name_node = get_node(name_path)
	type_node = get_node(type_path)
	effect_node = get_node(effect_path)
	reach_node = get_node(reach_path)
	aoe_node = get_node(aoe_path)
	anim_node = get_node(anim_path)
	name_node.connect("value_changed", self,"update_skill")
	type_node.connect("value_changed", self,"update_skill")
	effect_node.connect("value_changed", self,"update_skill")
	reach_node.connect("value_changed", self,"update_skill")
	aoe_node.connect("value_changed", self,"update_skill")
	anim_node.connect("value_changed", self,"update_skill")
	
func save_to_file():
	var file = File.new()
	file.open(FILE_PATH, file.WRITE)
	file.store_16(skills.size())
	print(skills.size())
	for u in skills:
		file.store_pascal_string(u.name)
		file.store_16(u.type)
		file.store_float(u.effect)
		file.store_16(u.reach)
		file.store_16(u.aoe)
		file.store_pascal_string(u.anim)
		
func load_from_file():
	var file = File.new()
	if(!file.file_exists(FILE_PATH)): return
	file.open(FILE_PATH, file.READ)
	
	var skillCount = file.get_16()
	for i in range(skillCount):
		skills.append(SkillData.new())
		skills[i].name = file.get_pascal_string()
		skills[i].type = file.get_16()
		skills[i].effect = file.get_float()
		skills[i].reach = file.get_16()
		skills[i].aoe = file.get_16()
		skills[i].anim = file.get_pascal_string()
		add_item(skills[i].name)
func _on_SaveButton_button_up():
	save_to_file()
func update_skill():
	skills[selectedIdx].name = name_node.get_value()
	skills[selectedIdx].type = type_node.get_value()
	skills[selectedIdx].effect = effect_node.get_value()
	skills[selectedIdx].reach = reach_node.get_value()
	skills[selectedIdx].aoe = aoe_node.get_value()
	skills[selectedIdx].anim = anim_node.get_value()
func display_skill(index):
	selected = skills[index]
	selectedIdx = index
	name_node.set_value(skills[index].name) 
	type_node.set_value(skills[index].type)
	effect_node._on_text_changed(skills[index].effect)
	reach_node._on_text_changed(skills[index].reach)
	aoe_node._on_text_changed(skills[index].aoe)
	anim_node.set_txt(skills[index].anim)
	pass
func _on_AddSkill_button_up():
	skills.append(SkillData.new())
	add_item("<unnamed>")
	select(skills.size()-1)
	display_skill(skills.size()-1)

func _on_RemoveSkill_button_up():
	remove_item(selectedIdx)
	skills.remove(selectedIdx)
	if(skills.size() > 0):
		if(selectedIdx > 0):
			display_skill(selectedIdx-1)
			select(selectedIdx)
		else:
			display_skill(0)
			select(0)
	else:
		editor_deselect()
func editor_deselect():
	selected = null
	selectedIdx = 0
func editor_select(index):
	selected = skills[index]
	selectedIdx = index
	display_skill(index)
func set_selected_name(n : String):
	selected.name = n
	if(n == "" || n == " "):
		set_item_text(selectedIdx, "<unnamed>")
	else:
		set_item_text(selectedIdx, n)