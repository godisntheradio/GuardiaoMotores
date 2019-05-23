extends State
class_name SelectingMoveTarget
func _init(fsm).(fsm):
	pass
func action(delta):
	if fsm.input_event is InputEventMouseButton && fsm.input_event.pressed && fsm.input_event.button_index == BUTTON_LEFT:
		if(get_fsm_owner().camera_manager.result.size() > 0):
			var tile = get_fsm_owner().camera_manager.result.collider.get_parent()
			if(tile is Tile):
				if(get_fsm_owner().is_move_valid(tile)):
					var path = get_fsm_owner().battle_manager.get_path_from_to(get_fsm_owner().selected_tile, tile)
					var world_path : PoolVector3Array
					for point in path:
						world_path.append(get_fsm_owner().battle_manager.map.get_tile(Vector2(point.x,point.y)).global_transform.origin)
					get_fsm_owner().selected_tile.occupying_unit.move(tile, world_path)
					get_fsm_owner().selected_tile.remove_unit()
					get_fsm_owner().after_move()
					get_fsm_owner().target_selected = true
					get_fsm_owner().battle_manager.astarManager.update_connections()
func entry_action():
	get_fsm_owner().target_selected = false
	pass
func exit_action():
	pass
static func get_name():
	return "Selecting Move Target"