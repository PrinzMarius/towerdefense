extends Node
signal tower_transfer(Tower:PackedScene)
signal player_damage(CurrentHealth:int,Damage:int)

func _emit_tower(Tower:PackedScene)->void:
	tower_transfer.emit(Tower)

func _emit_playerdamage(Damage:int)->void:
	player_damage.emit(Damage)
