extends CharacterBody3D

@export var HitBoxArea: Area3D
@export var HitBox: CollisionShape3D
@onready var tower:CharacterBody3D=get_parent()
@onready var target:CharacterBody3D=tower.target
@onready var AttackArray:Array=tower.AttackArray
var missle_direction: Vector3
var last_position:Vector3
signal hit(target:CharacterBody3D)

func initialize()->void:
	HitBoxArea.body_shape_entered.connect(_on_hit)
	
func _physics_process(_delta: float) -> void:
	if is_instance_valid(target)==true:
		last_position=target.global_position
	else:
		if (last_position-global_position).length()<HitBox.shape.height:
			queue_free()
	look_at(last_position)
	velocity=-get_global_transform().basis.z.normalized()*tower.MissleSpeed
	move_and_slide()


func _on_hit(_body_rid: RID, body: Node3D, _body_shape_index: int, _local_shape_index: int) -> void:
	if body==target:
		if body.is_killed==false:
			hit.emit(target)
		queue_free()
