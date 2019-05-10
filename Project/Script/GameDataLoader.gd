class UnitData:
	var name : String
	var hp : float
	var attack : float
	var defense : float
	var magic_attack : float
	var magic_defense : float
	var movement : int
	var skill_list : Array
	func _init():
		skill_list = []
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
enum { Area, Cross}
static func LoadUnitList(file : File) -> Array:
	var units = []
	var unitCount = file.get_16()
	for i in range(unitCount):
		units.append(UnitData.new())
		units[i].name = file.get_pascal_string()
		units[i].hp = file.get_float()
		units[i].attack = file.get_float()
		units[i].defense = file.get_float()
		units[i].magic_attack = file.get_float()
		units[i].magic_defense = file.get_float()
		units[i].movement = file.get_16()
		units[i].skill_list = LoadSkillList(file)
	return units
static func LoadSkillList(file : File) -> Array:
	var skills = []
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
	return skills
static func create_skill(data : SkillData) -> Skill:
	var skill : Skill
	match data.range_type:
		Area:
			skill = AreaSkill.new()
		Cross:
			skill = CrossSkill.new()
	skill.name = data.name
	skill.type = data.type
	skill.effect = data.effect
	skill.reach = data.reach
	skill.ignore = data.ignore
	skill.aoe = data.aoe
	skill.anim = load(data.anim)
	return skill
static func create_unit(data : UnitData) -> Stats:
	var stats : Stats = Stats.new()
	stats.hit_points = data.hp
	stats.name = data.name
	stats.attack = data.attack
	stats.defense = data.defense
	stats.magicAtk = data.magic_attack
	stats.magicDef = data.magic_defense
	stats.movement = data.movement
	for d in data.skill_list:
		var s := create_skill(d)
		stats.skills.append(s)
	return stats