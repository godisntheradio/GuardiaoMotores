extends Control

export var s_name_path : NodePath
export var s_desc_path : NodePath
export var s_difficulty_path : NodePath
export var difficulty_icon : Texture
var s_name : Label
var s_desc : RichTextLabel
var s_difficulty : BoxContainer
var selected
func _ready():
	s_name = get_node(s_name_path)
	s_desc = get_node(s_desc_path)
	s_difficulty = get_node(s_difficulty_path)
func set_desc_window(stage):
	for n in s_difficulty.get_children():
		n.queue_free()
	for i in range(stage.difficulty):
		var tex = TextureRect.new()
		s_difficulty.add_child(tex)
		tex.texture = difficulty_icon
		tex.expand = true
		tex.rect_min_size = Vector2(40,40)
		
	s_name.text = stage.stage_name
	s_desc.text = stage.description
func show_desc(stage):
	visible = true
	set_desc_window(stage)
	selected = stage
func _on_Button_pressed():
	get_parent().get_parent().load_stage(selected.to_load)


func _on_Close_pressed():
	visible = false
	selected = null
	pass # Replace with function body.
