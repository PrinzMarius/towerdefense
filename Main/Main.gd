extends Node3D
#Ready counters
@export var WaveMembers:int=2
var CreepNumber:int=1
var MassMod:int=1
var BossMod:int=0
#Export Nodes
@export var SpawnTimer:Timer
@export var WaveTimer:Timer
@export var MainPath:Path3D
@export var TowerPanel: TabContainer
#Ready Point
@onready var SpawnPoint1:Node3D = get_node("Points/SpawnPoint1")
@onready var CenterPoint:Node3D  = get_node("Points/CenterPoint")

#Wavedate
@export var WaveNumberList:GridContainer
@export var WaveTypeList:GridContainer
@export var WaveArmorList:GridContainer
@export var WaveAffixList:GridContainer
@export var WavePath: PackedScene
@export var Esquie: PackedScene
@export var MaxWave:int
var Wave:Array=[]
@export var affix_list:Array=[["Fast","Slow"],["Outlined","Chromatic"],["Wise","Rich","Packed"],["Cursive","Faded"],"Redraw","Stylish"]
@export var type_list:Array=["Base","Mass","Boss"]
@onready var baselist:Array=["Base","Mass","Boss"]
@onready var EraseString:String

var WaveNumber:int=0

signal round_end(Round:int)

func _ready() -> void: 
	MainPath.child_order_changed.connect(end_wave)
	WaveTimer.timeout.connect(start_wave)
	SpawnTimer.timeout.connect(_spawn_creep)
	round_end.connect(SignalBus._emit_round_end)
#generate Waves
	for ii:int in MaxWave:
		Wave.append(generate_wave(ii))
		if ii>2:

			if Wave[ii-1][1]==Wave[ii-2][1]:
				while Wave[ii][1]==Wave[ii-1][1]: 
					Wave.erase(Wave[ii])
					Wave.append(generate_wave(ii))
		
	write_waves()

func end_wave()->void:
	if GlobalFunctions.LivingCreeps<=0:
		WaveNumber+=1
		WaveTimer.start(60)
		write_waves()
		round_end.emit(WaveNumber)

func generate_wave(Number:int)->Array:
	var Affix:String=""
	randomize()
	type_list.shuffle()
	var Type:String=type_list[0]
	randomize()
	var ArmorType:Constants.Type=(randi() % 5) + 2
	if Number>10:
		affix_list.shuffle()
		for ii:int in range(0,2):
			if Number*2/(ii+1)>=randi_range(1,100):
				if affix_list[ii] is String:
					Affix+=affix_list[ii]+", "
				else:
					Affix+=affix_list[ii][randi_range(0,affix_list[ii].size()-1)]+", "
			if (ii==1 and Affix=="") or ii==affix_list.size():
				break
		if not Affix.is_empty():
			Affix=Affix.erase(Affix.length()-2,2)
	return [Number,Type,ArmorType,Affix]

func write_waves()->void:
	for ii:int in 5:
		WaveNumberList.get_child(ii+1).text=str(Wave[WaveNumber+ii][0])
		WaveTypeList.get_child(ii+1).text=Wave[WaveNumber+ii][1]
		WaveArmorList.get_child(ii+1).text=Constants.Type.keys()[Wave[WaveNumber+ii][2]].to_lower()
		WaveAffixList.get_child(ii+1).text=Wave[WaveNumber+ii][3]

func start_wave()->void:
	match Wave[WaveNumber][1]:
		"Mass": 
			BossMod=0
			MassMod=2
		"Boss": 
			MassMod=1
			BossMod=1
		"Base":
			MassMod=1
			BossMod=0
	SpawnTimer.start(0.75/MassMod)

func _spawn_creep()->void:

	if CreepNumber<=(WaveMembers*MassMod)**(1-BossMod):
		var WaveInstance:PathFollow3D = WavePath.instantiate()
		GlobalFunctions.LivingCreeps+=1
		MainPath.add_child(WaveInstance)
		var Creep_Node:CharacterBody3D =WaveInstance.get_child(0)
		Creep_Node.ArmorType.append(Wave[WaveNumber][2])
		Creep_Node.MaxHealth=(100+50*WaveNumber)*(WaveMembers**BossMod)/MassMod
		Creep_Node.Armor=1+floor(WaveNumber/5)
		Creep_Node.Score=(0.2*WaveNumber/10)*(WaveMembers**BossMod)/MassMod
		Creep_Node.Graphite=(10+WaveNumber*3)*(WaveMembers**BossMod)/MassMod
		Creep_Node.DropChance=(0.05+0.05*roundi(WaveNumber/25))*(WaveMembers**BossMod)/MassMod
		Creep_Node.MultiDrop=roundi((1+roundi(WaveNumber/50))/MassMod)+(2**BossMod)
		Creep_Node.apply_affix(Wave[WaveNumber][3])
		Creep_Node.initialize(SpawnPoint1.position,CenterPoint.position,Wave[WaveNumber][1])
		CreepNumber=CreepNumber+1
		
	else:
		CreepNumber=1
		BossMod=0
		MassMod=1
		SpawnTimer.stop()


func _on_node_3d_tower_built(NewTower: PackedScene, Location: Vector3) -> void:
	var BuiltTower:CharacterBody3D=NewTower.instantiate()
	add_child(BuiltTower)
	BuiltTower.global_position=Location
	BuiltTower.got_build()
	BuiltTower.MainNode=self
