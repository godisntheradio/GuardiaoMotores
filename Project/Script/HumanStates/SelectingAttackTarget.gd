extends State
class_name SelectingAttackTarget
func _init(fsm).(fsm):
	pass
func action():
	if fsm.input_event is InputEventMouseButton && !fsm.input_event.pressed && fsm.input_event.button_index == BUTTON_LEFT:
		if(get_fsm_owner().camera_manager.result.size() > 0):
			var tile = get_fsm_owner().camera_manager.result.collider.get_parent()
			if(tile is Tile):
				if(get_fsm_owner().is_attack_valid(tile)):
					get_fsm_owner().selected_tile.occupying_unit.attack(tile)
					get_fsm_owner().target_selected = true
					get_fsm_owner().after_move()
func entry_action():
	get_fsm_owner().target_selected = false
	pass
func exit_action():
	pass
static func get_name():
	pass