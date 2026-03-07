extends CharacterBody3D

#Preallocations
@export var Tooltip:String
@export var BuildCollisionArea:Area3D
@export var TargetingArea:Area3D
@export var Missle: PackedScene
@export var MissleSpawnPoint: Node3D
@export var SelectionRing: MeshInstance3D
@export var TowerStats: Control
@onready var enemy_list:Array=Array([], TYPE_OBJECT, "Node", null)
@onready var missle_list:Array=Array([], TYPE_OBJECT, "Node", null)
@onready var AttackArray : Array
@onready var SpellArray : Array
var target: Node3D

#Base Attack Values
@export var BaseAttackDamage: float
@export var AttackType: int
var AttackDamageMultiplicator:float=0
var AttackDamage: float

@export var BaseAttackSpeed: float
@onready var AttackSpeed: float=BaseAttackSpeed
var AttackDPS: float
@onready var AttackCooldown:float=1/BaseAttackSpeed

@export var AttackRange: int
@export var MissleSpeed: int
@onready var priority:String="First"

#Extended Attack Values
@export var CritChance: int
@export var CritDamage: int
@export var Multicrit: int
@export var Multihit: int

#Casting Values
@export var SpellDamage: int
@export var SpellCrit: int
@export var MultiSpell: int
@export var Ressource: int
@export var RessourceGeneration: float

#Leveling
@onready var EXP:float=0
@onready var BaseEXP:float=10
@onready var Level:int=1
@onready var MaxLevel:int=25
@onready var EXPCurve:Curve=Curve.new()

#Analytics
@onready var DPS:float=0
@onready var DPR:int=0
@onready var BestDPS:float=0
@onready var BestDPR:int=0
@onready var TotalDamage:int=0
@onready var TotalKills:int=0
@onready var is_built:bool=false
@onready var TimeCounter:float=0
@onready var DPSCalculator:float=0
@onready var DPRCalculator:float=0

@onready var hovered:bool=false
@onready var selected:bool=false

func _initiate()->void:
	TargetingArea.body_shape_entered.connect(_enemy_entered)
	TargetingArea.body_shape_exited.connect(_enemy_exited)
	BuildCollisionArea.mouse_entered.connect(_show_selectionring)
	BuildCollisionArea.mouse_exited.connect(_hide_selectionring)

func got_build()->void:
	for ii:int in MaxLevel:
		EXPCurve.add_point(Vector2(ii,BaseEXP+ii**2))
	TargetingArea.get_child(0).get_shape().radius=AttackRange
	is_built=true

func level_up()->void:
	BaseAttackDamage=BaseAttackDamage*1.1
	AttackSpeed+=BaseAttackSpeed*0.1
	Level+=1
	EXP=0

func stat_refresh(delta:float)->void:
	if is_built:
		AttackDamage=BaseAttackDamage*(100+AttackDamageMultiplicator)/100
		AttackDPS=AttackDamage*AttackSpeed
		AttackArray=[AttackDamage, CritChance, CritDamage, Multicrit, AttackType]
		SpellArray= [SpellDamage, SpellCrit, CritDamage, Multicrit]
		TimeCounter+=delta
		if TimeCounter>=10:
			DPS=DPSCalculator/10
			DPSCalculator=0
			if DPS>BestDPS:
				BestDPS=DPS
			TimeCounter=0
		if Level<MaxLevel:
			if EXP>=EXPCurve.get_point_position(Level).y:
				level_up()

func targeting_priority()->CharacterBody3D:
	var target_list:Array
	for ii:int in enemy_list.size():
		target_list.append([enemy_list[ii], enemy_list[ii].Pathtrack.progress, enemy_list[ii].CurrentHealth])
	match priority:
		"First":
			target_list.sort_custom(func(a:Array, b:Array)->bool: return a[1]<b[1])
		"Last":
			target_list.sort_custom(func(a:Array, b:Array)->bool: return a[1]>b[1])
		"Random":
			randomize()
			target_list.shuffle()
		"High HP":
			target_list.sort_custom(func(a:Array, b:Array)->bool: return a[2]<b[2])
		"Low HP":
			target_list.sort_custom(func(a:Array, b:Array)->bool: return a[2]>b[2])
	return target_list[0][0]

func basic_attack()->void:
	var new_Missle:CharacterBody3D=Missle.instantiate()
	new_Missle.initialize()
	new_Missle.hit.connect(_on_hit)
	add_child(new_Missle)
	missle_list.push_front(new_Missle)
	AttackCooldown=1/AttackSpeed
	new_Missle.global_position=MissleSpawnPoint.global_position
	new_Missle.look_at(target.position)

func attack_process(delta:float,attacktype:Callable)->void:
	if is_built:
		if AttackCooldown>0:
			AttackCooldown-=delta
		if enemy_list.is_empty()==false and AttackCooldown<=0:
			target=targeting_priority()
			attacktype.call()

func damage_process(EXPGained:float,Damage:float,is_kill:bool)->void:
	TotalDamage+=roundi(Damage)
	DPSCalculator+=Damage
	DPRCalculator+=Damage
	if is_kill:
		EXP+=EXPGained
		TotalKills+=1

func _enemy_exited(_body_rid: RID, body: Node3D, _body_shape_index: int, _local_shape_index: int) -> void:
	if enemy_list.is_empty()==false and is_instance_valid(body):
		enemy_list.remove_at(enemy_list.rfind(body))

func _enemy_entered(_body_rid: RID, body: Node3D, _body_shape_index: int, _local_shape_index: int) -> void:
	if body.name=="Creep":
		enemy_list.push_back(body)

func _on_hit(enemy:CharacterBody3D)->void:
	var DamageValues:Array=GlobalFunctions.damage_calc_base(AttackArray,enemy.ArmorArray)
	if enemy.Chromatic==true:
		var ChromaticDamage:Array=GlobalFunctions.damage_calc_base(AttackArray,[enemy.ArmorArray[0],enemy.ArmorArray[1],enemy.ChromaticArmor,enemy.ArmorArray[3]])
		if ChromaticDamage[0]>DamageValues[0]:
			DamageValues=ChromaticDamage
	enemy.damage_process(self,DamageValues[0],DamageValues[3])

func _show_selectionring() -> void:
	if is_built:
		hovered=true
		SelectionRing.visible=true

func _hide_selectionring() -> void:
	if is_built:
		hovered=false
		if selected==false:
			SelectionRing.visible=false

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("click_left"):
		if hovered:
			TowerStats.show()
			selected=true
		else:
			TowerStats.hide()
			selected=false
			_hide_selectionring()
			
	elif event.is_action_released("click_right"):
		pass
