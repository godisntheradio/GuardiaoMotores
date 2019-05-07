tool
extends Label
class_name Editor_unitSkills
var unit_list
export var available_list_path : NodePath
export var list_path : NodePath

var available_list : ItemList
var list : ItemList
const FILE_PATH = "res://skills.txt"

var skills = []
var unit_skills = []
class SkillData:
	var name : String
	var type : int
	var range_type : int
	var effect : float
	var reach : int
	var ignore : int
	var aoe : int
	var anim : String
	
	func init():
		name = "<unnamed>"
		type = -1
		range_type = -1
		effect = 0
		reach = 0
		ignore = 0
		aoe = 0
		anim = "<find path>"
func _enter_tree():
	available_list = get_node(available_list_path)
	list = get_node(list_path)
	unit_list = get_parent().get_node("UnitList")
	unit_list.select_connect(funcref(self, "_on_item_selected"))
	available_list.clear()
	load_from_file()
func _on_item_selected():
	if(unit_list.selected != null):
		list.clear()
		unit_skills.clear()
		# verificar se está carregando corretamente as skills
		for skill in unit_list.selected.skill_list:
			unit_skills.append(skill)
			list.add_item(skill.name)
func load_from_file():
	var file = File.new()
	if(!file.file_exists(FILE_PATH)): return
	file.open(FILE_PATH, file.READ)
	
	var skillCount = file.get_16()
	for i in range(skillCount):
		skills.append(SkillData.new())
		skills[i].name = file.get_pascal_string()
		skills[i].type = file.get_16()
		skills[i].range_type = file.get_16()
		skills[i].effect = file.get_float()
		skills[i].reach = file.get_16()
		skills[i].ignore = file.get_16()
		skills[i].aoe = file.get_16()
		skills[i].anim = file.get_pascal_string()
		available_list.add_item(skills[i].name)


func _on_AddSkills_pressed():
	var selected_indexes = available_list.get_selected_items()
	if (selected_indexes.size() < 1):
		return
	var id = selected_indexes[0]
	print(name.to_lower())
	unit_skills.append(skills[id])
	unit_list.selected.set(name.to_lower(), unit_skills)
	list.add_item(skills[id].name)

func _on_RemoveSkills_pressed():
	var selected_indexes = list.get_selected_items()
	if (selected_indexes.size() < 1):
		return
	var id = selected_indexes[0]
	unit_skills.remove(id)
	unit_list.selected.set(name.to_lower(), unit_skills)
	list.remove_item(id)