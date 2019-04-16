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
		print("oi")
		planes = get_tree().get_edited_scene_root().get_children().duplicate()
		for block in planes:
			print(block.name)
#			var tile = Spatial.new()
#			get_tree().get_edited_scene_root().add_child(tile)
#			var copy = block.duplicate()
#			tile.add_child(copy)
#			tile.set_script(tile_s_res)
			block.set_script(tile_fx_res)
			block.color = Color(1,1,1)