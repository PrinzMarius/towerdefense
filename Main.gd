extends Node3D
#Ready counters
var CreepNumber:int=10
var ii:int=0
#Ready Timers
@onready var SpawnTimer:Timer=get_node("Timer/SpawnTimer")
#Ready Point
@onready var SpawnPoint1:Node3D = get_node("Points/SpawnPoint1")
@onready var CenterPoint:Node3D  = get_node("Points/CenterPoint")
#Ready Enemies
@export var Wave1: PackedScene
@export var Esquie: PackedScene

#func _ready() -> void:


func _on_spawn_timer_timeout()->void:
	
	if ii<CreepNumber:
		var Wave:PathFollow3D = Wave1.instantiate()
		$Path3D.add_child(Wave)
		var Creep_Node:CharacterBody3D =Wave.get_child(0)
		Creep_Node.initialize(SpawnPoint1.position,CenterPoint.position)
		ii=ii+1
	else:
		ii=0
		SpawnTimer.stop()


func _on_node_3d_tower_built(NewTower: PackedScene, Location: Vector3) -> void:
	var BuiltTower:CharacterBody3D=NewTower.instantiate()
	add_child(BuiltTower)
	BuiltTower.global_position=Location
	BuiltTower.got_build()
