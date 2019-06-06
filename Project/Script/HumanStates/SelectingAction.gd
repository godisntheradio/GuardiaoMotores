extends State
class_name SelectingAction
func _init(fsm).(fsm):
	pass
func action(delta):
	if fsm.input_event is InputEventMouseButton && fsm.input_event.pressed && fsm.input_event.button_index == BUTTON_LEFT:
		if(get_fsm_owner().camera_manager.result.size() > 0):
			var tile = get_fsm_owner().camera_manager.result.collider.get_parent()
			if(tile is Tile && !tile.is_tile_empty() ):
				if(tile.occupying_unit.player == get_fsm_owner()):
					get_fsm_owner().select_unit(tile)
func entry_action():
	get_fsm_owner().deselect_action()
	get_fsm_owner().command_window.show_commands(get_fsm_owner().selected_tile.occupying_unit)
func exit_action():
	pass
static func get_name():
	return "Selecting Action"