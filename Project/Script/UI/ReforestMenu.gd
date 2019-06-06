extends Control

var selected_stage : Stage
var selected_index : int
var list : ItemList
var aura_list :Array

enum { SECO, HUMIDO, CAMPO, AQUATICO }
export var seco_tex : Texture
export var humido_tex : Texture
export var campo_tex : Texture
export var aquatico_tex : Texture


func _ready():
	aura_list = []
	list = get_node("Panel/ItemList")
func open_window(stage : Stage):
	visible = true
	set_window_stage(stage)
func close_window():
	visible = false
func set_window_stage(stage: Stage):
	aura_list = []
	list.clear()
	selected_stage = stage
	for type in stage.types_available:
		var a = get_vegetation_type_value(type)
		var stats_up_text = "Agua +"+str(a.agua)+" Terra +"+str(a.terra)+" Luz +"+str(a.luz)+" Escuridão +"+str(a.escuridao)
		list.add_item(stats_up_text, get_vegetation_type_tex(type))
		aura_list.append(a)
func get_vegetation_type_value(type):
	var aura = GameData.Aura.new()
	match type:
		SECO:
			aura.agua = 0
			aura.terra = 2
			aura.luz = 1
			aura.escuridao = 0
		HUMIDO:
			aura.agua = 1
			aura.terra = 2
			aura.luz = 0
			aura.escuridao = 0
		CAMPO:
			aura.agua = 0
			aura.terra = 1
			aura.luz = 2
			aura.escuridao = 0
		AQUATICO:
			aura.agua = 2
			aura.terra = 0
			aura.luz = 0
			aura.escuridao = 1
	return aura
func get_vegetation_type_tex(type):
	match type:
		SECO:
			return seco_tex
		HUMIDO:
			return humido_tex
		CAMPO:
			return campo_tex
		AQUATICO:
			return aquatico_tex

func _on_Vegetation_confirmed():
	selected_stage.reforest(selected_index)
	GameData.add_aura(aura_list[selected_index])
	close_window()
func _on_type_selected(index):
	get_node("Panel/Vegetation").popup()
	get_node("Panel/Vegetation").rect_position = Vector2(200,210)
	selected_index = index