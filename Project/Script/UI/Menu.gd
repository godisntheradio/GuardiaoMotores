extends Control

export(String, FILE, "*.tscn, *.scn") var overworld_scene : String

var fade_wait = false

func _on_GiveUp_pressed():
	CameraManager.fade_out()
	fade_wait = true

func _process(delta):
	if(fade_wait && CameraManager.is_fade_done()):
		get_tree().change_scene(overworld_scene)