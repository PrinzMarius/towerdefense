extends Tower


func _ready() -> void:
	MainAttack=basic_attack
	
func _process(delta: float) -> void:
	stat_refresh(delta)
	#stat_refresh(delta)

func _physics_process(delta: float) -> void:
	attack_process(delta)
	#attack_process(delta)
