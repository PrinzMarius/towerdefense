extends CharacterBody3D
@export var HealthBar: TextureProgressBar
@export var Pathtrack : PathFollow3D
@onready var ArmorArray: Array
@export var MovementSpeed: float
@export var Armor: float
@export var ArmorType: int
@export var MaxHealth: float

@onready var CurrentHealth:float=MaxHealth
@onready var is_killed:bool
@onready var EXP:float=1
@onready var Gold:float=10
@onready var DropChance:float=0.1
@onready var MultiDrop:int=1
@onready var DamageString:String
@onready var Playerdamage:int=2
@export var DamageLabelSettings:LabelSettings

#Affixes
@onready var Redraw:bool=false
@onready var RedrawCounter:int=0
@onready var Stylish:bool=false
@onready var Dodge:float=0
@onready var Chromatic:bool=false
@onready var ChromaticType:int=0

func _process(_delta:float)->void:
	ArmorArray=[MaxHealth, CurrentHealth, Armor, ArmorType]

func damage_process(Tower:CharacterBody3D,Damage:int,MultiCrit:int)->void:
	CurrentHealth-=Damage
	_create_damage_text(Damage,MultiCrit)
	is_killed=false
	HealthBar._update_bar(Damage)
	if CurrentHealth<=0:
		if Redraw==false:
			is_killed=true
			HealthBar.get_parent().get_parent().reparent(get_tree().root.get_child(0),true)
			Pathtrack.queue_free()
			@warning_ignore("integer_division")
		elif randi_range(1,100)<=(100/RedrawCounter):
			RedrawCounter+=1
			CurrentHealth=ceil(MaxHealth/(RedrawCounter+1))
	Tower.damage_process(EXP,Damage,is_killed)

func initialize(spawn_point:Vector3, center_point:Vector3)->void:
	global_position=spawn_point
	look_at(center_point,Vector3.UP)

#affix_list:Array=[["Fast","Slow"],["Armored","Chromatic"],["Wise","Rich","Packed"],"Redraw","Stylish"]
func apply_affix(Affix:String)->void:
	var Affixes:Array
	Affixes[0]=Affix.split(",")[0]
	Affixes[1]=Affix.split(",")[1].replace(" ","")
	for ii:int in 1:
		match Affixes[ii]:
			"Fast":
				MovementSpeed*=1.5
			"Slow":
				MovementSpeed*=0.75
			"Armored":
				Armor*=2
			"Bold":
				MaxHealth*=2
				CurrentHealth*=2
			"Cursive":
				Dodge+=0.25
			"Faded":
				Dodge+=0.5
				MaxHealth*=0.5
				CurrentHealth=MaxHealth
			"Chromatic":
				Chromatic=true
				var armor_list:Array=["0","1","2","3","4","5","6","7"]
				armor_list.shuffle()
				ChromaticType=armor_list[0]
			"Wise":
				EXP*=2
				Gold*=0.5
				DropChance*=0.75
			"Rich":
				EXP*=0.5
				Gold*=2
				DropChance*=0.75
			"Packed":
				EXP*=0.75
				Gold*=0.75
				DropChance*=2
				MultiDrop+=1
			"Redraw":
				Redraw=true
			"Stylish":
				Stylish=true

func _create_damage_text(Damage:float,MultiCrit:int)->void:
	var DamageLabel:Label=Label.new()
	HealthBar.add_sibling(DamageLabel)
	DamageLabel.text=str(GlobalFunctions.SIRound(Damage))
	for ii:int in MultiCrit:
		DamageLabel.text+="!"
	DamageLabel.label_settings=DamageLabelSettings
	#DamageLabel.position.y-=HealthBar.texture_progress.get_height()
