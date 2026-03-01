extends PathFollow3D
@export var LoseScreenScene: PackedScene
signal playerdamage
func _ready()->void:
	playerdamage.connect(SignalBus._emit_playerdamage)
func _physics_process(_delta:float)->void:
	progress+=$Creep.MovementSpeed * _delta
	if progress_ratio>0.98:
		playerdamage.emit($Creep.Playerdamage)
		if GlobalFunctions.PlayerHealth==0:
			var Lost:Control=LoseScreenScene.instantiate()
			get_tree().get_current_scene().add_child(Lost)
		queue_free()
