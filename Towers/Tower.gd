extends CharacterBody3D
class_name Tower

signal towerstat_updated(Name:String,value:float)
signal tower_selected(SelectionTower:CharacterBody3D)
#Preallocations
@export var MainTooltip:String
@export var BuildCollisionArea:Area3D
@export var TargetingArea:Area3D
@export var Missle: PackedScene
@export var MissleSpawnPoint: Node3D
@export var SelectionRing: MeshInstance3D
@export var TowerStats: Control
@onready var enemy_list:Array=Array([], TYPE_OBJECT, "Node", null)
@onready var missle_list:Array=Array([], TYPE_OBJECT, "Node", null)
var target: Node3D

#Base Attack Values
@export var BaseAttackDamage: float:
	set(value):
		towerstat_updated.emit("BaseAttackDamage",value)
		BaseAttackDamage=value
		AttackDamage=BaseAttackDamage*AttackDamageModifier
@export var AttackType: Constants.Type

var on_hit_effects:Array[Callable]
var AttackDamageModifier:float=1:
	set(value):
		towerstat_updated.emit("AttackDamageModifier",value)
		AttackDamageModifier=value
		AttackDamage=BaseAttackDamage*AttackDamageModifier

var AttackDamage: float

@export var BaseAttackSpeed: float:
	set(value):
		towerstat_updated.emit("BaseAttackSpeed",value)
		BaseAttackSpeed=value

@onready var AttackSpeed: float:
	get():
		AttackSpeed=BaseAttackSpeed*AttackSpeedModifier
		return AttackSpeed

@onready var AttackSpeedModifier: float=1:
	set(value):
		towerstat_updated.emit("AttackSpeedModifier",value)
		AttackSpeedModifier=value

@onready var AttackCooldown:float=1/BaseAttackSpeed

@export var AttackRange: int
@export var MissleSpeed: int
@onready var priority:String="Last"

#Extended Attack Values
@export var CritChance: int:
	set(value):
		towerstat_updated.emit("CritChance",value)
		CritChance=value

@export var CritDamage: float=1:
	set(value):
		towerstat_updated.emit("CritDamage",value)
		CritDamage=value

@export var MultiCrit: int:
	set(value):
		towerstat_updated.emit("MultiCrit",value)
		MultiCrit=value

@export var Multihit: int:
	set(value):
		towerstat_updated.emit("Multihit",value)
		Multihit=value

#Casting Values
@export var Intensity: int:
	set(value):
		towerstat_updated.emit("Intensity",value)
		Intensity=value

@export var Trace: int:
	set(value):
		towerstat_updated.emit("Trace",value)
		Trace=value

@export var Pool: int:
	set(value):
		towerstat_updated.emit("Pool",value)
		Pool=value

@export var Flourish: int:
	set(value):
		towerstat_updated.emit("Flourish",value)
		Flourish=value

@export var Cure: float:
	set(value):
		towerstat_updated.emit("Cure",value)
		Cure=value
		
@export var Flow: float:
	set(value):
		towerstat_updated.emit("Flow",value)
		Flow=value


#Misc
@export var Inspiration: float:
	set(value):
		towerstat_updated.emit("Inspiration",value)
		Inspiration=value

@export var Creativity: float:
	set(value):
		towerstat_updated.emit("Creativity",value)
		Creativity=value

@export var Consistency: float:
	set(value):
		towerstat_updated.emit("Consistency",value)
		Consistency=value

@export var Yield: float:
	set(value):
		towerstat_updated.emit("Yield",value)
		Yield=value

@export var Dilligence: float:
	set(value):
		towerstat_updated.emit("Dilligence",value)
		Dilligence=value

@onready var Score:float=0:
	set(value):
		towerstat_updated.emit("Score",value)
		Score=value
		if Grade<MaxGrade:
			if Score>=ScoreCurve.get_point_position(Grade).y:
				grade_up()

@onready var BaseScore:float=10

@onready var Grade:int=1:
	set(value):
		towerstat_updated.emit("Grade",value)
		Grade=value

@onready var MaxGrade:int=18
@onready var ScoreCurve:Curve

#Analytics
@onready var DPS:float=0:
	set(value):
		DPS=value
		towerstat_updated.emit("DPS",value)
		if DPS>BestDPS:
			BestDPS=DPS

@onready var DPR:int=0:
	set(value):
		DPR=value
		towerstat_updated.emit("DPR",value)
		if DPR>BestDPR:
			BestDPR=DPR

@onready var BestDPS:float=0:
	set(value):
		BestDPS=value
		towerstat_updated.emit("BestDPS",value)

@onready var BestDPR:int=0:
	set(value):
		BestDPR=value
		towerstat_updated.emit("BestDPR",value)

@onready var TotalDamage:int=0:
	set(value):
		TotalDamage=value
		towerstat_updated.emit("TotalDamage",value)

@onready var TotalKills:int=0:
	set(value):
		TotalKills=value
		towerstat_updated.emit("TotalKills",value)

@onready var is_built:bool=false
@onready var TimeCounter:float=0
@onready var DPSCalculator:float=0
@onready var DPRCalculator:int=0

@onready var hovered:bool=false
@onready var selected:bool=false
@onready var MainNode:Node3D
@onready var MainAttack:Callable
#Tooltips
@export var CritTooltipTemplate:String


func _signal_connection()->void:
	TargetingArea.body_shape_entered.connect(_enemy_entered)
	TargetingArea.body_shape_exited.connect(_enemy_exited)
	BuildCollisionArea.mouse_entered.connect(_show_selectionring)
	BuildCollisionArea.mouse_exited.connect(_hide_selectionring)
	SignalBus.round_end.connect(round_end_process)
	towerstat_updated.connect(SignalBus._emit_towerstat_changed)
	tower_selected.connect(SignalBus._emit_tower_selected)

func got_build()->void:
	ScoreCurve=GlobalFunctions.calculate_grade_curve(MaxGrade,BaseScore)
	TargetingArea.get_child(0).get_shape().radius=AttackRange
	_signal_connection()
	is_built=true

func grade_up()->void:
	BaseAttackDamage=BaseAttackDamage*1.1
	AttackSpeed+=BaseAttackSpeed*0.1
	Grade+=1
	towerstat_updated.emit("ScoreUp",ScoreCurve.get_point_position(Grade).y)
	Score=0

func stat_refresh(delta:float)->void:
	if is_built:
		TimeCounter+=delta
		if TimeCounter>=10:
			if DPSCalculator!=0:
				DPS=DPSCalculator/10
				DPSCalculator=0
				TimeCounter=0

func targeting_priority()->CharacterBody3D:
	var target_list:Array
	for ii:int in enemy_list.size():
		target_list.append([enemy_list[ii], enemy_list[ii].Pathtrack.progress, enemy_list[ii].CurrentHealth])
	match priority:
		"First":
			target_list.sort_custom(func(a:Array, b:Array)->bool: return a[1]>b[1])
		"Last":
			target_list.sort_custom(func(a:Array, b:Array)->bool: return a[1]<b[1])
		"Random":
			randomize()
			target_list.shuffle()
		"High HP":
			target_list.sort_custom(func(a:Array, b:Array)->bool: return a[2]>b[2])
		"Low HP":
			target_list.sort_custom(func(a:Array, b:Array)->bool: return a[2]<b[2])
	return target_list[0][0]

func basic_attack()->void:
	var new_Missle:CharacterBody3D=Missle.instantiate()
	new_Missle.initialize()
	new_Missle.hit.connect(_on_hit)
	add_child(new_Missle)
	missle_list.push_front(new_Missle)	
	new_Missle.global_position=MissleSpawnPoint.global_position
	new_Missle.look_at(target.position)

func attack_process(delta:float)->void:
	if is_built:
		if AttackCooldown>0:
			AttackCooldown-=delta
		if enemy_list.is_empty()==false and AttackCooldown<=0:
			target=targeting_priority()
			MainAttack.call()
			AttackCooldown=1/AttackSpeed


func round_end_process(_RoundNumber:int)->void:
	DPR=DPRCalculator
	DPRCalculator=0

func _enemy_exited(_body_rid: RID, body: Node3D, _body_shape_index: int, _local_shape_index: int) -> void:
	if enemy_list.is_empty()==false and is_instance_valid(body) and not body.is_killed:
		enemy_list.remove_at(enemy_list.rfind(body))

func _enemy_entered(_body_rid: RID, body: Node3D, _body_shape_index: int, _local_shape_index: int) -> void:
	if body.name=="Creep":
		enemy_list.push_back(body)

func _on_hit(enemy:CharacterBody3D)->void:
	print("hit transferred")
	for ii:int in Multihit+1:
		var CritCount:int=0
		for jj:int in MultiCrit+1:
			if randi_range(1,100)<=CritChance:
				CritCount+=1
			else:
				break
		var Damage:int=roundi(AttackDamage+AttackDamage*(CritCount*CritDamage))
		var DamageTransferArray:Array=enemy.damage_process(Damage,MultiCrit,AttackType)
		TotalDamage+=DamageTransferArray[0]
		DPSCalculator+=DamageTransferArray[0]
		DPRCalculator+=DamageTransferArray[0]
		if !on_hit_effects.is_empty():
			var kk:int=0
			while !DamageTransferArray[2] and kk<=on_hit_effects.size():
				on_hit_effects[ii].call()
				kk+=1
		if DamageTransferArray[2] :
			enemy_list.remove_at(enemy_list.rfind(DamageTransferArray[3]))
			Score+=DamageTransferArray[1]
			TotalKills+=1
			enemy._kill()

func _show_selectionring() -> void:
	AttackDamageModifier+=5
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
			for Stats:Dictionary in get_property_list():
				if get(Stats.name) is int or get(Stats.name) is float:
					towerstat_updated.emit(Stats.name,get(Stats.name))
				elif Stats.name=="ScoreCurve":
					towerstat_updated.emit("ScoreUp",get(Stats.name).get_point_position(Grade).y)
			tower_selected.emit(self)
			selected=true
		else:
			TowerStats.hide()
			selected=false
			_hide_selectionring()
			
	elif event.is_action_released("click_right"):
		pass
