extends Node
signal tower_transfer(Tower:PackedScene)
	
func _emit_tower(Tower:PackedScene)->void:
	tower_transfer.emit(Tower)
