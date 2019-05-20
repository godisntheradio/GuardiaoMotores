extends Control

signal returning
signal attack
signal move

var speed = 5
export var skill_list_path : NodePath
var skill_list : ItemList
#redirecionar os eventos de botão para o Human tratar 
var skill_animator : AnimationPlayer
var move_animator: AnimationPlayer
func _ready():
	skill_animator = get_node("Panel/Skill/AnimationPlayer")
	move_animator = get_node("Panel/Move/AnimationPlayer")
	skill_animator.playback_speed = speed
	move_animator.playback_speed = speed
	skill_list = get_node("Panel/SkillList")
func _on_MoveButton_button_up():
	move_out()
	emit_signal("move")
func _on_ReturnButton_button_up():
	emit_signal("returning")
	
func show_commands(unit):
	add_skill_list(unit.stats.skills)
	visible = true #cuida da visibilidade da janela de comandos
	if(unit.has_attacked):
		hide_skill()
	else:
		show_skill()
	if(unit.has_moved):
		hide_move()
	else:
		show_move()
	pass
func hide_commands():
	visible = false
func move_out():
	hide_skill()
	hide_move()
func move_in():
	show_skill()
	show_move()
func show_skill():
	skill_animator.play_backwards("move_out")
func show_move():
	move_animator.play_backwards("move_out")
func hide_skill():
	skill_list.visible = false
	skill_animator.play("move_out")
func hide_move():
	move_animator.play("move_out")
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
	
func _on_SkillButton_pressed():
	move_out()
	skill_list.visible = true
	pass # Replace with function body.
