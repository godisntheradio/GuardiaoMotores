tool
extends "res://addons/Dock/info_input.gd"

func _on_text_changed(new_text : String):
	var temp = new_text
	text = ""
	for c in new_text:
		if(c == "0" || c.to_int() != 0):
			append_at_cursor(c)
	._on_text_changed(text)
	
func _ready():
	pass