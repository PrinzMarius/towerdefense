extends TextureProgressBar


func _ready() -> void:
	SignalBus.player_damage.connect(_update_bar)

func _update_bar(damage:int)->void:
	var tween:Tween=create_tween()
	tween.tween_property(self, "value", value-damage, 0.5)
