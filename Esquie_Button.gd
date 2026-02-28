extends Button
signal buildingTower(Tower:PackedScene)
@export var Tower: PackedScene
func _ready() -> void:
	buildingTower.connect(SignalBus._emit_tower)
func _pressed() -> void:
		buildingTower.emit(Tower)
