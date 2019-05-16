extends State
class_name SelectingAttackTarget
var aoe_tiles = []
func _init(fsm).(fsm):
	pass
func action(delta):
	var tile
	for t in aoe_tiles:
		t.aoe_blink_exit()
	aoe_tiles.clear()
	if(get_fsm_owner().camera_manager.result.size() > 0):
		tile = get_fsm_owner().camera_manager.result.collider.get_parent()
		if(tile is Tile):
			var found = get_fsm_owner().within_reach.find(tile)
			if(found != -1):
				aoe_tiles = get_fsm_owner().selected_skill.get_aoe_tiles(get_fsm_owner().battle_manager, tile)
				for t in aoe_tiles:
					t.aoe_blink_enter()
	if fsm.input_event is InputEventMouseButton && !fsm.input_event.pressed && fsm.input_event.button_index == BUTTON_LEFT:
		if(tile is Tile):
			if(get_fsm_owner().is_attack_valid(tile)):
				for t in aoe_tiles:
					if(t.occupying_unit != null && t.occupying_unit):
						get_fsm_owner().selected_tile.occupying_unit.attack(t,get_fsm_owner().selected_skill)
				get_fsm_owner().target_selected = true
				get_fsm_owner().after_move()
	
func entry_action():
	get_fsm_owner().target_selected = false
	pass
func exit_action():
	for t in aoe_tiles:
		t._on_RigidBody_mouse_exited()
	pass
static func get_name():
	return "Selecting Attack Target"