extends CharacterBody3D
@export var HealthBar: TextureProgressBar
@export var Pathtrack : PathFollow3D
@onready var ArmorArray: Array
@export var MovementSpeed: int
@export var Armor: int
@export var ArmorType: int
@export var MaxHealth: int

@onready var CurrentHealth:int=MaxHealth
@onready var is_killed:bool
@onready var EXP:int=1
@onready var DamageString:String
@onready var Playerdamage:int=2
@export var DamageLabelSettings:LabelSettings

func _process(_delta:float)->void:
	ArmorArray=[MaxHealth, CurrentHealth, Armor, ArmorType]

func damage_process(Tower:CharacterBody3D,Damage:int,MultiCrit:int)->void:
	CurrentHealth-=Damage
	_create_damage_text(Damage,MultiCrit)
	is_killed=false
	_update_bar(Damage)
	if CurrentHealth<=0:
		is_killed=true
		HealthBar.get_parent().get_parent().reparent(get_tree().root.get_child(0),true)
		Pathtrack.queue_free()
	Tower.damage_process(EXP,Damage,is_killed)

	
func initialize(spawn_point:Vector3, center_point:Vector3)->void:
	global_position=spawn_point
	look_at(center_point,Vector3.UP)
	
func _update_bar(damage:int)->void:
	var tween:Tween=create_tween()
	tween.tween_property(HealthBar, "value", HealthBar.value-damage, 0.1)

func _create_damage_text(Damage:float,MultiCrit:int)->void:
	var DamageLabel:Label=Label.new()
	HealthBar.add_sibling(DamageLabel)
	DamageLabel.text=str(GlobalFunctions.SIRound(Damage))
	for ii:int in MultiCrit:
		DamageLabel.text+="!"
	DamageLabel.label_settings=DamageLabelSettings
	#DamageLabel.position.y-=HealthBar.texture_progress.get_height()
