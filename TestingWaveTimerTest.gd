extends Label

func _process(_delta: float) -> void:
	text=str(ceili($"../../Timer/WaveTimer".time_left))
