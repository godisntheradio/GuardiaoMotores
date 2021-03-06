extends Control

var item_list
var UnitClass = preload("res://Objects/Units/Unit.tscn")
var input
var map

var GameDataLoader = preload("res://Script/GameDataLoader.gd")

var to_be_positioned
var to_be_positioned_index

var positioned_count = 0
var deployed_units = []
var instanced_units = []
signal begin_battle

export var battle_manager_path : NodePath
var bm


func _ready():
	bm = get_node(battle_manager_path)
	map = bm.map
	item_list = get_node("Panel/ItemList")
	item_list.connect("item_selected",self,"_on_selected_from_list")
	connect("begin_battle",bm,"on_begin_battle")
	input = CameraManager
	# load list
	item_list.set_same_column_width(true)
	item_list.set_max_text_lines(50)
	item_list.set_auto_height(true)
	item_list.clear()
	for unit in GameData.available_units:
		item_list.add_item(unit)
	for t in map.mapTiles:
		if(t.starting_position):
			t.highlight_movable()
	
func _process(delta):
	CameraManager.processCameraMovement(delta)
	if(to_be_positioned != null):
		if(input.result.size() > 0):
			var tile = input.result.collider.get_parent()
			if(tile is Tile):
				to_be_positioned.global_transform.origin = tile.global_transform.origin + Vector3(0,2.0,0)
		else:
			to_be_positioned.global_transform.origin = input.dir.normalized() * 2
func _input(event):
	if event is InputEventMouseButton && event.pressed && event.button_index == BUTTON_LEFT: # clique esquerdo posiciona uma unidade selecionada na lista no campo
		if(input.result.size() > 0 && to_be_positioned != null):#checa se o raycast colidiu com algo e se há uma unidade selecionada para posicionar
			var tile = input.result.collider.get_parent()
			if(tile is Tile):
				position_unit(to_be_positioned, tile)
	if event is InputEventMouseButton && event.pressed && event.button_index == BUTTON_RIGHT: # clique direito tira uma unidade do campo e retorna para a lista caso deseje reposicionar
		if(input.result.size() > 0 && to_be_positioned == null): #checa se o raycast colidiu com algo e se nao tem nada selecionado para posicionar
			var tile = input.result.collider.get_parent()
			if(tile is Tile && !tile.is_tile_empty()): #chega se a colisao foi com um tile e se tile possui uma unidade para tirar do campo
				var i = instanced_units.find(tile.occupying_unit)
				if (i != -1):
					var item_list_i = deployed_units[i]
					reactivate(item_list_i)
					deployed_units.remove(i)
					instanced_units.remove(i)
					positioned_count += -1
					var a = tile.occupying_unit
					tile.highlight_movable()
					tile.remove_unit()
					a.call_deferred("free")
	
func position_unit(new_unit : Unit, tile : Tile):
	if(tile.is_tile_empty() && !tile.blocked && tile.starting_position):
		tile.occupying_unit = new_unit
		positioned_count += 1
		deployed_units.append(to_be_positioned_index)
		instanced_units.append(to_be_positioned)
		tile.stop_highlight()
		deactivate()
	pass
func make_unit(unit_data):
	var instance
	var stats = GameDataLoader.create_unit(unit_data)
	var model = load(unit_data.model)
	if(model):
		instance = model.instance()
		bm.get_child(0).add_child(instance)
		instance.stats = stats
		instance.hp = stats.hit_points
		instance.add_skill_anims()
	else:
		instance = UnitClass.instance()
		bm.get_child(0).add_child(instance)
		instance.stats = stats
		instance.hp = stats.hit_points
		instance.get_node("MeshInstance").mesh = CapsuleMesh.new()
	return instance
func _on_selected_from_list(index):
	if(!item_list.is_item_disabled(index)):
		if(to_be_positioned != null):
			deselect()
		select(index)
		item_list.release_focus()

func _on_ItemList_mouse_exited():
	input.allowed_to_cast = true
	pass
	
func _on_ItemList_mouse_entered():
	input.allowed_to_cast = false
	pass
#funções relacionadas ao clique do mouse
func deselect():
	to_be_positioned.queue_free()
	
	to_be_positioned_index = -1
func select(index):
	
	to_be_positioned_index = index
	var found_unit = GameData.find_unit(item_list.get_item_text(index))
	if (found_unit != null):
		to_be_positioned =  make_unit(found_unit)
	else:
		print("nao achou unidade na lista")
#funções relacionadas a lista
func deactivate():
	item_list.set_item_disabled(to_be_positioned_index, true)
	item_list.unselect( to_be_positioned_index)
	to_be_positioned = null
	to_be_positioned_index = -1
func reactivate(index):
	item_list.set_item_disabled(index, false )


func _on_Begin_button_up():
	if (positioned_count > 0):
		for t in map.mapTiles:
			if(t.starting_position):
				t.stop_highlight()
		emit_signal("begin_battle",instanced_units)
		call_deferred("free")
	pass # Replace with function body.
