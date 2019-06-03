extends Control

export(String, FILE, "*.tscn") var summaryClass : String
var summary
export(Array,String) var unlockable_units : Array
export(Array,Array,int) var requirements

var refs : Array
func _ready():
	summary = load(summaryClass)
	var container = get_node("Panel/ScrollContainer/GridContainer")
	for u in unlockable_units:
		var a = GameData.find_unit(u)
		if(a != null):
			refs.append(a)
	for i in range(refs.size()):
		var s = summary.instance()
		container.add_child(s)
		var aura = GameData.Aura.new()
		aura.agua = requirements[i][0]
		aura.terra = requirements[i][1]
		aura.luz = requirements[i][2]
		aura.escuridao = requirements[i][3]
		s.set_unit_stats(refs[i],aura)
