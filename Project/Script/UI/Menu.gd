extends Control

export(String, FILE, "*.tscn, *.scn") var overworld_scene : String

func _on_GiveUp_pressed():
	get_tree().change_scene(overworld_scene)