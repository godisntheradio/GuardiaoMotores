tool
extends Control

var tile_s_res = preload("res://Script/Tile.gd")
var tile_fx_res = preload("res://Script/TileEffectManager.gd")


export var planes = []
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_button_up():
#	planes.clear()
	if(get_tree().get_edited_scene_root().name == "Scene Root"):
		for block in get_tree().get_edited_scene_root().get_children():
			planes.append(block)
		for plane in planes:
			var tile = Spatial.new()
			get_tree().get_edited_scene_root().add_child(tile)
			tile.set_owner(get_tree().get_edited_scene_root())
			
			get_tree().get_edited_scene_root().remove_child(plane)
			tile.add_child(plane)
			plane.set_owner(tile)
			
			tile.set_script(tile_s_res)
			plane.set_script(tile_fx_res)
			plane.color = Color(1,1,1)

func _on_Button2_button_up():
	for block in planes:
		print(block.name)
	pass # Replace with function body.
