extends Control

export var unlock_path : NodePath
var unlock : Node

export var agua_path : NodePath
export var terra_path : NodePath
export var luz_path : NodePath
export var escuro_path : NodePath
export var audio : NodePath
var audio_player : AudioStreamPlayer2D
var agua_value : Label
var terra_value : Label
var luz_value : Label
var escuro_value : Label
func _ready():
	audio_player = get_node(audio)
	agua_value = get_node(agua_path)
	terra_value = get_node(terra_path)
	luz_value = get_node(luz_path)
	escuro_value = get_node(escuro_path)
	unlock = get_node(unlock_path)
	GameData.connect("changed_aura",self,"refresh")
func change_values(aura):
	agua_value.text = str(aura.agua)
	terra_value.text = str(aura.terra)
	luz_value.text = str(aura.luz)
	escuro_value.text = str(aura.escuridao)

func _on_open_unlock_window_pressed():
	visible = false
	unlock.visible = true
	unlock.connect("close",self,"on_close_unlock_window")
	audio_player.play()
func on_close_unlock_window():
	if(!visible):
		visible = true
func refresh():
	change_values(GameData.aura)