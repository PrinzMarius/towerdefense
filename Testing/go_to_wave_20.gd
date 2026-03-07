extends Button

func _pressed() -> void:
	$"../..".WaveNumber=50
	$"../..".write_waves()
