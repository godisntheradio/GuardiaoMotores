extends Control

export var s_name_path : NodePath
export var s_desc_path : NodePath
export var s_difficulty_path : NodePath
export var difficulty_icon : Texture
var s_name : Label
var s_desc : RichTextLabel
var s_difficulty : BoxContainer
func _ready():
	s_name = get_node(s_name_path)
	s_desc = get_node(s_desc_path)
	s_difficulty = get_node(s_difficulty_path)
func set_desc_window(stage : Stage):
	for n in s_difficulty.get_children():
		n.queue_free()
	for i in range(stage.difficulty):
		var tex = TextureRect.new()
		tex.texture = difficulty_icon
		s_difficulty.add_child(tex)
	s_name.text = stage.stage_name
	s_desc.text = stage.description