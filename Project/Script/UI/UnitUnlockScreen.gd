extends Control

export(String, FILE, "*.tscn") var summaryClass : String
var summary
export(Array,String) var unlockable_units : Array
export(Array,Array,int) var requirements

signal close

var refs : Array
func _ready():
	summary = load(summaryClass)
	refresh()
func _process(delta):
	if(Input.is_action_just_released("ui_cancel")):
		close_window()
func close_window():
	visible = false
	emit_signal("close")
func refresh():
	var container = get_node("Panel/ScrollContainer/GridContainer")
	refs.clear()
	for i in container.get_children():
		i.free()
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
	get_node("Panel/PlayerStats").change_values(GameData.aura)

func _on_UnitUnlockScreen_visibility_changed():
	refresh()