extends "res://Towers/Tower.gd"

func _ready() -> void:
	_initiate()
	$TowerStats.write_tower_stats()
	
func _process(delta: float) -> void:
	stat_refresh(delta)
	#stat_refresh(delta)

func _physics_process(delta: float) -> void:
	attack_process(delta,basic_attack)
	#attack_process(delta)
