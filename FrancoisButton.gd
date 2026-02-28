extends Button
@onready var SpawnTimer:Timer=get_node("../../Timer/SpawnTimer")

var stylebox: StyleBox =get_theme_stylebox("normal")
func _toggled(toggled_on:bool)->void:
	if toggled_on:
		SpawnTimer.start(1)
	else: 
		SpawnTimer.stop()
