tool
extends ItemList

const FILE_PATH = "res://skills.txt"

var skills : Array = []
var GameDataLoader = preload("res://Script/GameDataLoader.gd")

var selected = null
var selectedIdx : int

export var name_path : NodePath
export var type_path : NodePath
export var range_type_path : NodePath
export var effect_path : NodePath
export var reach_path : NodePath
export var ignore_path : NodePath
export var aoe_path : NodePath
export var anim_path : NodePath

var name_node
var type_node
var range_type_node
var effect_node
var reach_node
var ignore_node
var aoe_node
var anim_node

func _ready():
	name_node = get_node(name_path)
	type_node = get_node(type_path)
	range_type_node = get_node(range_type_path)
	effect_node = get_node(effect_path)
	reach_node = get_node(reach_path)
	ignore_node = get_node(ignore_path)
	aoe_node = get_node(aoe_path)
	anim_node = get_node(anim_path)
	
	name_node.connect("value_changed", self,"update_skill")
	type_node.connect("value_changed", self,"update_skill")
	range_type_node.connect("value_changed", self,"update_skill")
	effect_node.connect("value_changed", self,"update_skill")
	reach_node.connect("value_changed", self,"update_skill")
	ignore_node.connect("value_changed", self,"update_skill")
	aoe_node.connect("value_changed", self,"update_skill")
	anim_node.connect("value_changed", self,"update_skill")
	clear()
	load_from_file()
func save_to_file():
	var file = File.new()
	file.open(FILE_PATH, file.WRITE)
	file.store_16(skills.size())
	print(skills.size())
	for u in skills:
		file.store_pascal_string(u.name)
		file.store_16(u.type)
		file.store_16(u.range_type)
		file.store_float(u.effect)
		file.store_16(u.reach)
		file.store_16(u.ignore)
		file.store_16(u.aoe)
		file.store_pascal_string(u.anim)
		
func load_from_file():
	var file = File.new()
	if(!file.file_exists(FILE_PATH)): return
	file.open(FILE_PATH, file.READ)
	skills = GameDataLoader.LoadSkillList(file)
	for skill in skills:
		add_item(skill.name)
func _on_SaveButton_button_up():
	save_to_file()
func update_skill():
	skills[selectedIdx].name = name_node.get_value()
	skills[selectedIdx].type = type_node.get_value()
	skills[selectedIdx].range_type = range_type_node.get_value()
	skills[selectedIdx].effect = effect_node.get_value()
	skills[selectedIdx].reach = reach_node.get_value()
	skills[selectedIdx].ignore = ignore_node.get_value()
	skills[selectedIdx].aoe = aoe_node.get_value()
	skills[selectedIdx].anim = anim_node.get_value()
func display_skill(index):
	selected = skills[index]
	selectedIdx = index
	name_node.set_value(skills[index].name) 
	type_node.set_value(skills[index].type)
	range_type_node.set_value(skills[index].range_type)
	effect_node.set_value(skills[index].effect)
	reach_node.set_value(skills[index].reach)
	ignore_node.set_value(skills[index].ignore)
	aoe_node.set_value(skills[index].aoe)
	anim_node.set_value(skills[index].anim)
	pass
func _on_AddSkill_button_up():
	skills.append(GameDataLoader.SkillData.new())
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