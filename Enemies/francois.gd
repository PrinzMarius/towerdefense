extends CharacterBody3D
@export var HealthBar: TextureProgressBar
@export var Pathtrack : PathFollow3D
@export var MovementSpeed: float
@export var Armor: float
@onready var ArmorType: Array[int]
@export var MaxHealth: float

@onready var CurrentHealth:float:
	set(value):
		CurrentHealth=value
		HealthBar._update_bar(CurrentHealth/MaxHealth*100)

@onready var is_killed:bool
@onready var Score:float
@onready var Graphite:int
@onready var DropChance:float=0.1
@onready var MultiDrop:int=1
@onready var DamageString:String
@onready var PlayerDamage:int=2
@export var DamageLabelSettings:LabelSettings

#Affixes
@onready var Redraw:bool=false
@onready var RedrawCounter:int=1
@onready var Stylish:bool=false
@onready var Dodge:int=0
@onready var Chromatic:bool=false
@onready var ChromaticType:int=0

func damage_process(TowerDamage:int,DamageType:Constants.Type,MultiCrit:int)->Array:
	var TypeModifier:float=0
	var ArmorModifier:float=Armor/(100+Armor)
	for ii:Constants.Type in ArmorType:
		TypeModifier=max(TypeModifier,GlobalFunctions.damage_table(DamageType,ii))
	var Damage:int=roundi(TowerDamage*TypeModifier*ArmorModifier)
	CurrentHealth-=Damage
	is_killed=false
	_handle_damage_text(Damage,MultiCrit)
	if CurrentHealth<=0:
		if Redraw and randi_range(1,100)<=(100/RedrawCounter):
			RedrawCounter+=1
			CurrentHealth=ceil(MaxHealth/(RedrawCounter+1))
		else:
			is_killed=true
			MovementSpeed=0
	return[Damage,Score,is_killed]


func initialize(spawn_point:Vector3, center_point:Vector3,Type:String)->void:
	match Type:
		"Mass":
			scale*=0.75
		"Boss":
			scale*=1.5
	CurrentHealth=MaxHealth
	global_position=spawn_point
	look_at(center_point,Vector3.UP)

#affix_list:Array=[["Fast","Slow"],["Armored","Chromatic"],["Wise","Rich","Packed"],"Redraw","Stylish"]
func apply_affix(Affix:String)->void:
	var Affixes:Array=[""]
	Affixes=Affix.replace(" ","").split(",")
	for ii:int in Affixes.size():
		match Affixes[ii]:
			"Fast":
				MovementSpeed*=1.5
			"Slow":
				MovementSpeed*=0.75
			"Outlined":
				Armor*=2
			"Bold":
				MaxHealth*=2
				CurrentHealth*=2
			"Cursive":
				Dodge+=25
			"Faded":
				Dodge+=50
				MaxHealth*=0.5
				CurrentHealth=MaxHealth
			"Chromatic":
				Chromatic=true
				ArmorType.append((randi() % 6)+2)
			"Wise":
				Score*=2
				Graphite*=0.5
				DropChance*=0.75
			"Rich":
				Score*=0.5
				Graphite*=2
				DropChance*=0.75
			"Packed":
				Score*=0.75
				Graphite*=0.75
				DropChance*=2
				MultiDrop+=1
			"Redraw":
				Redraw=true
			"Stylish":
				Stylish=true

func _handle_damage_text(Damage:float,MultiCrit:int)->void:
	var DamageLabel:Label=Label.new()
	HealthBar.add_sibling(DamageLabel)
	HealthBar._move_damage_text(DamageLabel)
	DamageLabel.text=str(GlobalFunctions.SIRound(Damage))
	if Damage<1000:
		DamageLabel.text=DamageLabel.text.split(".")[0]
	for ii:int in MultiCrit:
		DamageLabel.text+="!"
	DamageLabel.label_settings=DamageLabelSettings

func _kill()->void:
	if is_killed:
		PlayerValues.change_player_value(PlayerValues.type.GRAPHITE,Graphite)
		var tween:Tween=create_tween().set_parallel(true)
		for Recolor:MeshInstance3D in find_children("*","MeshInstance3D"):
				Recolor.get_mesh().get_material().albedo_color-=Color(0,1,1,0)
				tween.tween_property(Recolor.get_mesh().get_material(),"albedo_color",Recolor.get_mesh().get_material().albedo_color-Color(0,0,0,1),2)
		await tween.finished
		Pathtrack.queue_free()
