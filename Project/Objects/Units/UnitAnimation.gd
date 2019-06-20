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
	animator.play("idle")
func play_run():
	animator.play("run")