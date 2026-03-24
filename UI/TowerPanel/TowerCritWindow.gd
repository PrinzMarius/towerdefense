extends GridContainer
var AverageCrit:float=0
var Stats:Dictionary={
	"CritDamage":0,
	"CritChance":0,
	"MultiCrit":0
}

var AverageDPSCritMultiplier:float:
	get():
		if Stats["MultiCrit"]==0:
			return Stats["CritChance"]
		if Stats["MultiCrit"]>0:
			for ii:int in range(1,Stats["MultiCrit"]):
				AverageCrit+=ii*Stats["CritChance"]*(Stats["CritChance"]/Stats["MultiCrit"])**(ii-1)*(1-Stats["CritChance"]/Stats["MultiCrit"])
			AverageCrit+=(Stats["MultiCrit"]+1)*Stats["CritChance"]*(Stats["CritChance"]/Stats["MultiCrit"])**Stats["MultiCrit"]
		return AverageCrit


@onready var TooltipTemplate:String="Every hit from an Attack can be multiplied by %s with a chance of %s %%.\n
										Additionaly has another chance of %s %% to crit again up to %s times.\n
										Average Crits per Attack: %s"
func _ready() -> void:
	SignalBus.towerstat_changed.connect(_update_Label)

func _update_Label(Name:String,value:float)->void:
	if Name in Stats:
		Stats[Name]=value
	else:
		return
	if find_children("Values")[0].find_children(Name).is_empty()==false:
		find_children("Values")[0].find_children(Name)[0].text=GlobalFunctions.SIRound(value)
		tooltip_text=TooltipTemplate % GlobalFunctions.SIRoundArray([Stats["CritChance"],Stats["CritDamage"],Stats["CritChance"],Stats["MultiCrit"],AverageDPSCritMultiplier])
