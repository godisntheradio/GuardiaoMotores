extends Control

var item_list
var UnitClass = preload("res://Objects/Unit.tscn")
var input
var map

var to_be_positioned
var to_be_positioned_index

func _ready():
	item_list = get_node("Panel/ItemList")
	item_list.connect("item_activated",self,"_on_selected_from_list")
	map = get_tree().get_root().get_node("Main/Map")
	input = get_tree().get_root().get_node("Main/PlayerInput")
	# load list
	item_list.set_same_column_width(true)
	item_list.set_max_text_lines(50)
	item_list.set_auto_height(true)
	for unit in PlayerData.available_units:
		item_list.add_item(unit.name + "   " )


func _physics_process(delta):
	if(to_be_positioned != null):
		if(input.result.size() > 0):
			var tile = input.result.collider.get_parent()
			if(tile is Tile):
				to_be_positioned.global_transform.origin = tile.global_transform.origin + Vector3(0,3.0,0)
		else:
			to_be_positioned.global_transform.origin = input.dir.normalized() * 2
	pass
func _process(delta):
	if(Input.is_action_pressed("left_click")):
		if(input.result.size() > 0 && to_be_positioned != null):
			var tile = input.result.collider.get_parent()
			if(tile is Tile):
				position_unit(to_be_positioned, tile)
	if(Input.is_action_just_released("right_click")):
		if(input.result.size() > 0 && to_be_positioned == null):
			var tile = input.result.collider.get_parent()
			if(tile is Tile):
				reactivate(PlayerData.available_units.find(tile.occupying_unit.name))
				tile.remove_unit()
	
func position_unit(new_unit : Unit, tile : Tile):
	if(tile.occupying_unit == null):
		tile.occupying_unit = new_unit
		deactivate()
	pass
	
func make_unit(stats):
	var instance = UnitClass.instance()
	get_tree().get_root().get_node("Main").add_child(instance)
	instance.stats = stats
	instance.hp = stats.hit_points
	return instance
func _on_selected_from_list(index):
	if(to_be_positioned != null):
		deselect()
	select(index)
	pass

func _on_ItemList_mouse_exited():
	input.allowed_to_cast = true
	print("saiu")
	pass # Replace with function body.


func _on_ItemList_mouse_entered():
	print("entrou")
	input.allowed_to_cast = false
	pass # Replace with function body.

func deselect():
	to_be_positioned.free()
	to_be_positioned_index = -1
func deactivate():
	item_list.set_item_disabled ( to_be_positioned_index, true )
	item_list.unselect( to_be_positioned_index)
	to_be_positioned = null
	to_be_positioned_index = -1
func reactivate(index):
	item_list.set_item_disabled ( to_be_positioned_index, false )
func select(index):
	to_be_positioned_index = index
	to_be_positioned =  make_unit(PlayerData.available_units[index])