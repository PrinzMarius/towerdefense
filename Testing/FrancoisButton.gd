extends Button
@onready var WaveTimer: Timer=get_node("../../Timer/WaveTimer")

var stylebox: StyleBox =get_theme_stylebox("normal")
func _toggled(toggled_on:bool)->void:
	if toggled_on:
		WaveTimer.start(5)
	else: 
		WaveTimer.stop()
