extends Spatial

var available_units = []

func _ready():
	var unit1 = Stats.new()
	unit1.hit_points = 50.0
	unit1.name = "unit1"
	unit1.attack = 10.0
	unit1.defense = 10.0
	unit1.magicAtk = 5.0
	unit1.magicDef = 5.0
	var unit2 = Stats.new()
	unit2.hit_points = 50.0
	unit2.name = "unit2"
	unit2.attack = 10.0
	unit2.defense = 10.0
	unit2.magicAtk = 5.0
	unit2.magicDef = 5.0
	var unit3 = Stats.new()
	unit3.hit_points = 50.0
	unit3.name = "unit3"
	unit3.attack = 10.0
	unit3.defense = 10.0
	unit3.magicAtk = 5.0
	unit3.magicDef = 5.0
	available_units.append(unit1)
	available_units.append(unit2)
	available_units.append(unit3)
	pass