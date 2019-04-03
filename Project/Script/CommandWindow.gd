extends Control

signal deselected
signal attack
signal move

#redirecionar os eventos de botão para o Human tratar 

func _ready():
	pass # Replace with function body.


func _on_AttackButton_button_up():
	move_out()
	emit_signal("attack")
	pass # Replace with function body.


func _on_MoveButton_button_up():
	move_out()	
	emit_signal("move")
	pass # Replace with function body.


func _on_ReturnButton_button_up():
	move_in()
	emit_signal("deselected")
	pass # Replace with function body.
func move_out():
	get_node("ItemList/Control/AnimationPlayer").playback_speed = 2
	get_node("ItemList/Control/AnimationPlayer").play("move_out")
func move_in():
	get_node("ItemList/Control/AnimationPlayer").playback_speed = -2
	get_node("ItemList/Control/AnimationPlayer").play("move_out")