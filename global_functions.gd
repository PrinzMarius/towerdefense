extends Node
#			Neutral
# Neutral
@onready var NeutralTable:Array=[1,1.1,1.2,1.3,1.4]
@onready var TestTable:Array=[2,2.1,2.2,2.3,2.4]
@onready var DamageTable:Array=[NeutralTable, TestTable]
@onready var PlayerHealth:int=100
@onready var buildModeOn:bool=false

func _ready() -> void:
	SignalBus.player_damage.connect(deal_player_damage)
	

func deal_player_damage(Damage:int)->void:
	PlayerHealth-=Damage

func get_object_under_mouse(Camera:Camera3D, user:Node)->Dictionary:
	var mouse_pos:Vector2 = get_viewport().get_mouse_position()
	var ray_from:Vector3 = Camera.project_ray_origin(mouse_pos)
	var ray_to:Vector3 = ray_from + Camera.project_ray_normal(mouse_pos) * 444
	var space_state:PhysicsDirectSpaceState3D = user.get_world_3d().direct_space_state
	var selection:Dictionary = space_state.intersect_ray(PhysicsRayQueryParameters3D.create(ray_from, ray_to))
	return selection

func damage_table(AttackArray:Array,ArmorArray:Array)->int:
	var AttackType:int=AttackArray[4]
	var ArmorType:int=ArmorArray[3]
	return DamageTable[AttackType][ArmorType]

func kill_creep(unit:Node)->void:
	unit.get_parent().queue_free()
	
func SIRound(input:float)->String:
	var unitstring:String=""
	var value:float=0
	if input!=0: 
		var Order:int=floori(log(input)/log(10))
		if Order>2 and Order<6:
			unitstring="k"
		else: if Order>5 and Order<10:
			unitstring="M"
		else: if Order>9 and Order<12:
			unitstring="G"
		value=round(input/10**(Order-fmod(Order,3)-2))/10**2
		var ValueArray:Array=str(value).split(".")
		var ValueString:String=str("%*.*f" % [ValueArray[0].length(), 3-ValueArray[0].length(), value])
		return(str(ValueString," ",unitstring))
	else: 
		return(str(0," ",unitstring))

# AttackArray=[AttackDamage,CritChance,CritDamage, MultiCrit, AttackType]
# DefenseArray=[MaxHealth, CurrentHealth, Armor, ArmorType]
func damage_calc_base(AttackArray:Array,DefenseArray:Array)->Array:
	var CritCount:int=0
	var OverkillDamage:float=0
	var CritDamage:float=1+float(AttackArray[2])/100
	for ii:int in range(1,AttackArray[3]+1):
		var CritGenerator:RandomNumberGenerator=RandomNumberGenerator.new()
		var CritCheck:int=CritGenerator.randi_range(1,100)
		if CritCheck<=AttackArray[1]:
			CritCount+=1
	var Damage:int=roundi((AttackArray[0]*(CritDamage**CritCount)-DefenseArray[2])*damage_table(AttackArray,DefenseArray))
	if Damage<0:
		Damage=0
	var NewHealth:int=DefenseArray[1]-Damage
	if NewHealth<0:
		OverkillDamage=-NewHealth
	return [Damage,OverkillDamage,NewHealth,CritCount]
