extends Spatial

var available_units = []


func _ready():
	var unit1 = Stats.new()
	unit1.hit_points = 50.0
	unit1.name = "unit1"
	unit1.attack = 10.0
	unit1.defense = 3.0
	unit1.magicAtk = 5.0
	unit1.magicDef = 3.0
	unit1.movement = 1
	var unit2 = Stats.new()
	unit2.hit_points = 30.0
	unit2.name = "unit2"
	unit2.attack = 4.0
	unit2.defense = 5.0
	unit2.magicAtk = 5.0
	unit2.magicDef = 10.0
	unit2.movement = 2
	var unit3 = Stats.new()
	unit3.hit_points = 50.0
	unit3.name = "unit3"
	unit3.attack = 10.0
	unit3.defense = 10.0
	unit3.magicAtk = 5.0
	unit3.magicDef = 5.0
	unit3.movement = 3
	available_units.append(unit1)
	available_units.append(unit2)
	available_units.append(unit3)
	pass
	
func find_unit_index(to_find):
	for i in available_units.size():
		if(available_units[i].name == to_find.stats.name):
			return i