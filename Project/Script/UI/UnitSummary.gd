extends Control
class_name UnitSummary

export var name_path : NodePath
export var hp_path : NodePath
export var hp_text : NodePath
export var attack_path : NodePath 
export var defense_path : NodePath
export var mag_atk_path : NodePath
export var mag_def_path : NodePath
export var mov_path : NodePath
export var agua_path : NodePath
export var terra_path : NodePath
export var luz_path : NodePath
export var escuro_path : NodePath

export var invalid_color : Color

var name_value : Label
var hp_value : ProgressBar
var hp_text_value : Label
var attack_value : Label 
var defense_value : Label
var mag_atk_value : Label
var mag_def_value : Label
var mov_value : Label
var agua_value : Label
var terra_value : Label
var luz_value : Label
var escuro_value : Label

var redeemable : bool

var GameDataLoader = preload("res://Script/GameDataLoader.gd")

func _ready():
	redeemable = true
	name_value = get_node(name_path)
	hp_value = get_node(hp_path)
	hp_text_value = get_node(hp_text)
	attack_value = get_node(attack_path)
	defense_value = get_node(defense_path)
	mag_atk_value = get_node(mag_atk_path)
	mag_def_value = get_node(mag_def_path)
	mov_value = get_node(mov_path)
	agua_value = get_node(agua_path)
	terra_value = get_node(terra_path)
	luz_value = get_node(luz_path)
	escuro_value = get_node(escuro_path)
func set_unit_stats(unit, aura):
	name_value.text = unit.name
	hp_value.max_value = unit.hp
	hp_value.value = unit.hp
	hp_text_value.text = str(unit.hp)
	attack_value.text = str(unit.attack)
	defense_value.text = str(unit.defense)
	mag_atk_value.text = str(unit.magic_attack)
	mag_def_value.text = str(unit.magic_defense)
	mov_value.text = str(unit.movement)
	agua_value.text = str(aura.agua)
	terra_value.text = str(aura.terra)
	luz_value.text = str(aura.luz)
	escuro_value.text = str(aura.escuridao)
	if(GameData.aura.agua < aura.agua):
		agua_value.add_color_override("font_color",invalid_color)
		redeemable = false
	if(GameData.aura.terra < aura.terra):
		terra_value.add_color_override("font_color",invalid_color)
		redeemable = false
	if(GameData.aura.luz < aura.luz):
		luz_value.add_color_override("font_color",invalid_color)
		redeemable = false
	if(GameData.aura.escuridao < aura.escuridao):
		escuro_value.add_color_override("font_color",invalid_color)
		redeemable = false
	if(GameData.has_unit(unit.name)):
		get_node("SelectButton").disabled = true

func _on_SelectButton_pressed():
	if(redeemable):
		get_node("SelectButton").disabled = true
		GameData.available_units.append(name_value.text)
	else:
		print("not enough aura")