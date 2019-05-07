extends Control

signal returning
signal attack
signal move

var speed = 5
export var skill_list_path : NodePath
var skill_list : ItemList
#redirecionar os eventos de botão para o Human tratar 

func _ready():
	get_node("Panel/Attack/AnimationPlayer").playback_speed = speed
	get_node("Panel/Move/AnimationPlayer").playback_speed = speed
	skill_list = get_node("Panel/SkillList")

func _on_AttackButton_button_up():

	pass # Replace with function body.


func _on_MoveButton_button_up():
	move_out()
	emit_signal("move")
	pass # Replace with function body.


func _on_ReturnButton_button_up():
	move_in()
	emit_signal("returning")
	pass # Replace with function body.
func move_out():
	hide_attack()
	hide_move()
func move_in():
	show_attack()
	show_move()
func show_attack():
	get_node("Panel/Attack/AnimationPlayer").play_backwards("move_out")
func show_move():
	get_node("Panel/Move/AnimationPlayer").play_backwards("move_out")
func hide_attack():
	get_node("Panel/Attack/AnimationPlayer").play("move_out")
func hide_move():
	get_node("Panel/Move/AnimationPlayer").play("move_out")
func _on_CommandWindow_visibility_changed():
	move_in()
func add_skill_list(list):
	clear_skill_list()
	for i in list:
		skill_list.add_item(i.name)
func clear_skill_list():
	skill_list.clear()
func _on_SkillList_item_selected(index):
	move_out()
	emit_signal("attack", index)
	pass # Replace with function body.
