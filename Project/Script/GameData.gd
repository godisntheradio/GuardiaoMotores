extends Spatial
class Aura:
	var terra : int
	var agua : int
	var luz : int
	var escuridao : int
	func _init():
		terra = 0
		agua = 0
		luz = 0
		escuridao = 0
var available_units = [] # indexes pro game_units
var aura : Aura
var world_map_camera_pos : Vector3
var playtime
var index_to_load = 0

var game_units = [] # guarda unidade em UnitData de gamedataloader, usar funçao da mesma para transformar em stats
var to_load : String

var GameDataLoader = preload("res://Script/GameDataLoader.gd")
const FILE_PATH = "res://units.txt"
const SAVE_PATH = "res://save"
const PLAYER_UNITS_KEY = "player_units"
const TERRA_KEY = "terra"
const AGUA_KEY = "agua"
const ESCURIDAO_KEY = "escuridao"
const LUZ_KEY = "luz"
const CAMERA_POS_KEY = "c_pos"
const DATE_KEY = "date"
const PLAYTIME_KEY = "playtime"
const SAVE_NAME_TEMPLATE = "save_%03d.tres"
func _ready():
	aura = Aura.new()
	var file : File = File.new()
	if file.file_exists(FILE_PATH):
		file.open(FILE_PATH, file.READ)
		game_units = GameDataLoader.LoadUnitList(file)
	playtime = 0
	init_game()
	
func init_game():
	var saved = load_game(index_to_load)
	#get data from save
	available_units = saved.data[PLAYER_UNITS_KEY]
	aura.luz = saved.data[TERRA_KEY]
	aura.agua = saved.data[AGUA_KEY]
	aura.luz = saved.data[LUZ_KEY]
	aura.escuridao = saved.data[ESCURIDAO_KEY]
	world_map_camera_pos = saved.data[CAMERA_POS_KEY]
	playtime = saved.data[PLAYTIME_KEY]
	CameraManager.relocate(world_map_camera_pos)
func find_unit_index(to_find):
	for i in available_units.size():
		if(available_units[i].name == to_find.stats.name):
			return i
	return null
func find_unit(name):
	for unit in game_units:
		if(unit.name == name):
			return unit
	return null
func _process(delta):
	#if (Input.is_action_just_released("restart")):
	#	get_tree().change_scene("res://Objects/Main.tscn")
	playtime = playtime + delta
func save_game(id : int = 0):
	var saved : SavedGameData = SavedGameData.new()
	saved.game_version = ProjectSettings.get_setting("application/config/Version")
	saved.data[PLAYER_UNITS_KEY] = available_units
	saved.data[TERRA_KEY] = aura.terra
	saved.data[AGUA_KEY] = aura.agua
	saved.data[LUZ_KEY] = aura.luz
	saved.data[ESCURIDAO_KEY] = aura.escuridao
	saved.data[CAMERA_POS_KEY] = CameraManager.global_transform.origin
	saved.data[DATE_KEY] = OS.get_date()
	saved.data[PLAYTIME_KEY] = playtime
	var dir := Directory.new()
	if !dir.dir_exists(SAVE_PATH):
		dir.make_dir_recursive(SAVE_PATH)
	var save_path =  SAVE_PATH.plus_file(SAVE_NAME_TEMPLATE % id)
	var error = ResourceSaver.save(save_path, saved)
	if (error != OK):
		print('error saving %s to %s' % [id,save_path])
func load_game(id:int = 0):
	var save_file_path = SAVE_PATH.plus_file(SAVE_NAME_TEMPLATE % id)
	var file  = File.new()
	if(!file.file_exists(save_file_path)):
		print("coundn't find %s" % save_file_path)
		return
	var saved = load(save_file_path)
	return saved