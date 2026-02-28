extends PathFollow3D
@export var LoseScreenScene: PackedScene

func _physics_process(_delta:float)->void:
	progress+=$Creep.MovementSpeed * _delta
	if progress_ratio>0.98:
		GlobalFunctions.PlayerHealth-=1
		print(GlobalFunctions.PlayerHealth)
		if GlobalFunctions.PlayerHealth==0:
			var Lost:Label=LoseScreenScene.instantiate()
			get_tree().get_current_scene().add_child(Lost)
		queue_free()
