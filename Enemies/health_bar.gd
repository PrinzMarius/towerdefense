extends TextureProgressBar

func _update_bar(damage:int)->void:
	var tween:Tween=create_tween()
	tween.tween_property(self, "value", value-damage, 0.1)
