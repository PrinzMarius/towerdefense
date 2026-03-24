extends PathFollow3D
@export var LoseScreenScene: PackedScene

func _physics_process(_delta:float)->void:
	progress+=get_child(0).MovementSpeed * _delta
	if progress_ratio>0.98:
		PlayerValues.change_player_value(PlayerValues.type.PLAYERHP,-get_child(0).PlayerDamage)
		if GlobalFunctions.PlayerHealth==0:
			var Lost:Control=LoseScreenScene.instantiate()
			get_tree().get_current_scene().add_child(Lost)
		queue_free()

func _exit_tree() -> void:
	GlobalFunctions.LivingCreeps-=1
