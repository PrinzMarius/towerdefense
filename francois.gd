extends CharacterBody3D
@export var HealthBar: TextureProgressBar
@export var Pathtrack : PathFollow3D
@onready var ArmorArray: Array
@export var DamageTextScene: PackedScene
@export var MovementSpeed: int
@export var Armor: int
@export var ArmorType: int
@export var MaxHealth: int

@onready var CurrentHealth:int=MaxHealth
@onready var is_killed:bool
@onready var EXP:int=8
@onready var DamageString:String

func _process(_delta:float)->void:
	ArmorArray=[MaxHealth, CurrentHealth, Armor, ArmorType]
	HealthBar.value=float(CurrentHealth)/MaxHealth*100

func damage_process(Tower:CharacterBody3D,Damage:int,MultiCrit:int)->void:
	CurrentHealth-=Damage
	var DamageText:Sprite3D=DamageTextScene.instantiate()
	add_child(DamageText)
	DamageString=str(round(Damage))
	for ii:int in MultiCrit:
		DamageString+="!"
	DamageText.TextLabel.text=DamageString
	DamageText.position=HealthBar.get_parent().get_parent().position
	is_killed=false
	if CurrentHealth<=0:
		is_killed=true
		DamageText.reparent(get_tree().root.get_child(0),true)
		Pathtrack.queue_free()
	Tower.damage_process(EXP,Damage,is_killed)
	
func initialize(spawn_point:Vector3, center_point:Vector3)->void:
	global_position=spawn_point
	look_at(center_point,Vector3.UP)
