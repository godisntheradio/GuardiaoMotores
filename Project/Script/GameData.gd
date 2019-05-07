extends Spatial

var available_units = [] # indexes pro game_units
var game_units = [] # guarda unidade em UnitData de gamedataloader, usar funçao da mesma para transformar em stats
var to_load : String

var GameDataLoader = preload("res://Script/GameDataLoader.gd")

const FILE_PATH = "res://units.txt"
const SAVE_PATH = "res://save"
const PLAYER_UNITS_KEY = "player_units"
const SAVE_NAME_TEMPLATE = "save_%03d.tres"

func _ready():
	
	var file : File = File.new()
	if file.file_exists(FILE_PATH):
		file.open(FILE_PATH, file.READ)
		game_units = GameDataLoader.LoadUnitList(file)
	load_game()
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
	if (Input.is_action_just_released("restart")):
		get_tree().change_scene("res://Objects/Main.tscn")
func save_game(id : int = 0):
	var saved : SavedGameData = SavedGameData.new()
	saved.game_version = ProjectSettings.get_setting("application/config/Version")
	saved.data[PLAYER_UNITS_KEY] = available_units
	
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
	#get data from save
	available_units = saved.data[PLAYER_UNITS_KEY]