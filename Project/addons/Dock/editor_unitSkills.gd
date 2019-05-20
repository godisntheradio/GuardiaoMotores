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

var GameDataLoader = preload("res://Script/GameDataLoader.gd")

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
	skills = GameDataLoader.LoadSkillList(file)
	for i in skills:
		available_list.add_item(i.name)
	file.close()
func _on_AddSkills_pressed():
	var selected_indexes = available_list.get_selected_items()
	if (selected_indexes.size() < 1):
		return
	var id = selected_indexes[0]
	unit_skills.append(skills[id])
	unit_list.selected.set(name.to_lower(), unit_skills.duplicate())
	list.add_item(skills[id].name)

func _on_RemoveSkills_pressed():
	var selected_indexes = list.get_selected_items()
	if (selected_indexes.size() < 1):
		return
	var id = selected_indexes[0]
	unit_skills.remove(id)
	unit_list.selected.set(name.to_lower(), unit_skills.duplicate())
	list.remove_item(id)