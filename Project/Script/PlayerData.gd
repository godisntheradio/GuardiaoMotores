extends Spatial

var available_units = []
var to_load : String


const FILE_PATH = "res://units.txt"

func _ready():
	
	var file : File = File.new()
	if file.file_exists(FILE_PATH):
		file.open(FILE_PATH, file.READ)
		var unitCount = file.get_16()
		for i in range(unitCount):
			var unit = Stats.new()
			unit.name = file.get_pascal_string()
			unit.hit_points = file.get_float()
			unit.attack = file.get_float()
			unit.defense = file.get_float()
			unit.magicAtk = file.get_float()
			unit.magicDef = file.get_float()
			unit.movement = file.get_16()
			available_units.append(unit)
	else:
		var unit1 = Stats.new()
		unit1.hit_points = 50.0
		unit1.name = "unit1"
		unit1.attack = 10.0
		unit1.defense = 3.0
		unit1.magicAtk = 5.0
		unit1.magicDef = 3.0
		unit1.movement = 10
		var unit2 = Stats.new()
		unit2.hit_points = 30.0
		unit2.name = "unit2"
		unit2.attack = 4.0
		unit2.defense = 5.0
		unit2.magicAtk = 5.0
		unit2.magicDef = 10.0
		unit2.movement = 4
		var unit3 = Stats.new()
		unit3.hit_points = 50.0
		unit3.name = "unit3"
		unit3.attack = 10.0
		unit3.defense = 10.0
		unit3.magicAtk = 5.0
		unit3.magicDef = 5.0
		unit3.movement = 6
		available_units.append(unit1)
		available_units.append(unit2)
		available_units.append(unit3)
	
func find_unit_index(to_find):
	for i in available_units.size():
		if(available_units[i].name == to_find.stats.name):
			return i
	return null
func _process(delta):
	if (Input.is_action_pressed("restart")):
		get_tree().reload_current_scene()