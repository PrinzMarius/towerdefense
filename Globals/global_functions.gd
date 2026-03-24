extends Node

#AttackTable[AttackType][DefenseTyp], therefor the values represent how much 
#is blocked
# 								BLACK, PURPLE, BLUE, TEAL, GREEN, YELLOW, ORANGE, RED, WHITE}
@onready var BlackTable:Array= [0.5,      1.1,  1.2,  1.3,   1.4,    1.5,    1.6, 1.7,     1]
@onready var PurpleTable:Array=[0.5,      1.1,  1.2,  1.3,   1.4,    1.5,    1.6, 1.7,     1]
@onready var BlueTable:Array=  [0.5,      0.5,    1,    1,     1,      1,      1, 1.5,     1]
@onready var TealTable:Array=  [0.5,      1.1,  1.2,  1.3,   1.4,    1.5,    1.6, 1.7,     1]
@onready var GreenTable:Array= [0.5,      1.1,  1.2,  1.3,   1.4,    1.5,    1.6, 1.7,     1]
@onready var YellowTable:Array=[0.5,      1.1,  1.2,  1.3,   1.4,    1.5,    1.6, 1.7,     1]
@onready var OrangeTable:Array=[0.5,      1.1,  1.2,  1.3,   1.4,    1.5,    1.6, 1.7,     1]
@onready var RedTable:Array=   [0.5,      1.1,  1.2,  1.3,   1.4,    1.5,    1.6, 1.7,     1]
@onready var WhiteTable:Array= [0.5,      1.1,  1.2,  1.3,   1.4,    1.5,    1.6, 1.7,     1]
@onready var DamageTable:Array=[BlackTable, PurpleTable, BlueTable, TealTable,
								GreenTable, YellowTable, OrangeTable, RedTable, 
								WhiteTable]
@onready var PlayerHealth:int=100
@onready var buildModeOn:bool=false
@onready var LivingCreeps:int=0

func get_object_under_mouse(Camera:Camera3D, user:Node)->Dictionary:
	var mouse_pos:Vector2 = get_viewport().get_mouse_position()
	var ray_from:Vector3 = Camera.project_ray_origin(mouse_pos)
	var ray_to:Vector3 = ray_from + Camera.project_ray_normal(mouse_pos) * 444
	var space_state:PhysicsDirectSpaceState3D = user.get_world_3d().direct_space_state
	var selection:Dictionary = space_state.intersect_ray(PhysicsRayQueryParameters3D.create(ray_from, ray_to))
	return selection

func damage_table(AttackType:int,DefenseType:int)->float:
	return DamageTable[AttackType][DefenseType]
	
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

func SIRoundArray(input:Array[float])->Array[String]:
	var Result:Array[String]=[]
	for v:float in input:
		Result.append(SIRound(v))
	return Result

func calculate_grade_curve(maxgrade:int,basescore:int)->Curve:
	var result:Curve=Curve.new()
	result.min_value = 0
	result.max_value = basescore + maxgrade**2
	for ii:int in maxgrade:
		result.add_point(Vector2(ii,basescore+ii**2))
	return result
