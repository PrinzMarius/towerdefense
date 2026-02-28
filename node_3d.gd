extends Node3D

@export var EsquieScene: PackedScene
@export var FrancoisScene: PackedScene
@export var MissleScene: PackedScene
var Esquie: CharacterBody3D
var count=0
func _ready():
	Esquie=EsquieScene.instantiate()
	add_child(Esquie)
	Esquie.position=Vector3(10,0,10)
	print(Esquie.global_rotation_degrees)
	Esquie.look_at(self.position)
	print(Esquie.global_rotation_degrees)
	var Francois=FrancoisScene.instantiate()
	add_child(Francois)
	Francois.position=Vector3(0,0,-10)
	Francois.look_at(self.position)

func _process(delta: float) -> void:
	count+=1
	#if fmod(count,10)==0:
		#Esquie.rotate(Esquie.up_direction,deg_to_rad(90))
