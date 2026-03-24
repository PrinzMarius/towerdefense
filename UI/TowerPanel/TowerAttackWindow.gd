extends GridContainer
var BaseAttackDamage:int=0
var AttackDamageModifier:float=0
var AttackDamage:float:
	set(value):
		
		AttackDamage=value
	get():
		AttackDamage=BaseAttackDamage*AttackDamageModifier
		return AttackDamage

var AttackSpeed:float=0
var Multihit: int=0
var Stats:Dictionary={
	"AttackDamage":0,
	"BaseAttackDamage":0,
	"AttackDamageModifier":0,
	"AttackSpeed":0,
	"Multihit":0
}
@onready var TooltipTemplate:String="This tower deals %s x %s %%= %s per hit from an attack \n and attacks %s times per second hitting %s times."

func _ready() -> void:
	SignalBus.towerstat_changed.connect(_update_Label)

func _update_Label(Name:String,value:float)->void:
	if Name in Stats:
		Stats[Name]=value
	else:
		return
	if find_children("Values","GridContainer")[0].find_children(Name,"Label").is_empty()==false:
		find_children("Values","GridContainer")[0].find_children(Name,"Label")[0].text=GlobalFunctions.SIRound(value)
		tooltip_text=TooltipTemplate % GlobalFunctions.SIRoundArray([Stats["BaseAttackDamage"],Stats["AttackDamageModifier"],Stats["AttackDamage"],Stats["AttackSpeed"],Stats["Multihit"]])
	
	
