extends Control

signal deselected
signal attack
signal move

var speed = 3
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
	emit_signal("return")
	pass # Replace with function body.
func move_out():
	hide_attack()
	hide_move()
func move_in():
	get_node("ItemList/Attack/AnimationPlayer").playback_speed = -speed
	get_node("ItemList/Attack/AnimationPlayer").play("move_out")
	get_node("ItemList/Move/AnimationPlayer").playback_speed = -speed
	get_node("ItemList/Move/AnimationPlayer").play("move_out")
func hide_attack():
	get_node("ItemList/Attack/AnimationPlayer").playback_speed = speed
	get_node("ItemList/Attack/AnimationPlayer").play("move_out")
func hide_move():
	get_node("ItemList/Move/AnimationPlayer").playback_speed = speed
	get_node("ItemList/Move/AnimationPlayer").play("move_out")
func _on_CommandWindow_visibility_changed():
	move_in()
