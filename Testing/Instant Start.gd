extends Button
@export var WaveTimer:Timer
func _pressed() -> void:
	if WaveTimer.time_left>0:
		WaveTimer.stop()
		WaveTimer.timeout.emit()
