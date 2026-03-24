extends Button

func _pressed() -> void:
	PlayerValues.change_player_value(PlayerValues.type.SKILLPOINT,1)
