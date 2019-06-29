extends Spatial
export var Run : Animation
export var Idle : Animation
var Attack : Animation
var animator : AnimationPlayer


func _ready():
	animator = get_node("AnimationPlayer")
	animator.add_animation("run", Run)
	animator.add_animation("idle", Idle)
func play_idle():
	Idle.loop = true
	animator.play("idle")
func play_run():
	Run.loop = true
	animator.play("run")
func play_attack(anim_name):
	animator.get_animation(anim_name).loop = false
	animator.play(anim_name)
func _on_animation_finished(anim_name):
	if(anim_name != "run" && anim_name != "idle"):
		get_parent().emit_signal("action_finished")
