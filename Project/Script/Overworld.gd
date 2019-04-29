extends Spatial

export var battle_path : String

func _ready():
	get_node("Stage").connect("selected",self,"load_stage")
	pass
func load_stage(stage : String):
	GameData.to_load = stage
	get_tree().change_scene(battle_path)