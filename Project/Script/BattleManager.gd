extends Spatial

var map : Map

var astarManager
var AStarManager = load("res://Script/AStarManager.gd")

var canControl : bool = false
onready var PlayerInput = get_node("../PlayerInput")

func _ready():
	map = get_node("../Map")
	astarManager = AStarManager.new(map)

func _input(event):
	if(canControl):
		if event is InputEventMouseButton:
			if(PlayerInput.result.size() > 0):
				var t : Tile = PlayerInput.result.collider.get_parent()
				if(t.occupying_unit != null):
					var mov = astarManager.get_available_movement(map.world_to_map(t.translation), 3)
					for m in mov:
						var tile : Tile = map.get_tile(Vector2(m.x, m.y))
						tile.start_blinking()

func _on_DeployUnitsWindow_tree_exited():
	canControl = true
