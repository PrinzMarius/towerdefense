extends Button

@export var Knowledge:PlayerValues.knowledge

func _pressed() -> void:
	PlayerValues.allocate_classpoint(Knowledge,1)
