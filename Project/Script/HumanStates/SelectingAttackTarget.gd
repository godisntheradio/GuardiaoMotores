extends State

func action():
	if(get_fsm_owner().player_input.result.size() > 0):
		var tile = get_fsm_owner().player_input.result.collider.get_parent()
		if(tile is Tile):
			if(get_fsm_owner().is_attack_valid(tile)):
				get_fsm_owner().selected_tile.occupying_unit.attack(tile)
				get_fsm_owner().after_move()
func entry_action():
	pass
func exit_action():
	pass
static func get_name():
	pass