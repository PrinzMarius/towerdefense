extends GridContainer
const spawntime:float=0.5

func _ready()->void:
	PlayerValues.skillpoint_changed.connect(spawn)
	modulate.a=0

func spawn(value:int, previousvalue:int)->void:
	print(value,",",previousvalue)
	if value>previousvalue:
		var tween:Tween = create_tween()
		tween.tween_property(self, "modulate:a", 1, spawntime)
		for Buttons:Button in find_children("*","Button"):
			Buttons.disabled=false

	elif value==0:
		var tween:Tween = create_tween()
		tween.tween_property(self, "modulate:a", 0, spawntime)
		for Buttons:Button in find_children("*","Button"):
			Buttons.disabled=true
