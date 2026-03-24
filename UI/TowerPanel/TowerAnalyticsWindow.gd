extends GridContainer
var AverageCrit:float=0
var Stats:Dictionary={
	"AttackDamage":0,
	"AttackSpeed":0,
	"Multihit":0,
	"CritChance":0,
	"CritDamage":0,
	"MultiCrit":0
}
func _ready() -> void:
	SignalBus.towerstat_changed.connect(_update_Label)

func _update_Label(Name:String,value:float)->void:
	if Name=="DPS" or Name=="DPR":
		find_child("Real").find_child(Name).text=GlobalFunctions.SIRound(value)
		return
	if Name=="BestDPS" or Name=="BestDPR":
		find_child("Best").find_child(Name.replace("Best","")).text=GlobalFunctions.SIRound(value)
		return
	if Name=="TotalKills":
		find_child("Best").find_child(Name).text=GlobalFunctions.SIRound(value)
		return
	if Name=="TotalDamage":
		find_child("Real").find_child(Name).text=GlobalFunctions.SIRound(value)
		return
	if Stats.has(Name)==false:
		return
	Stats[Name]=value
	AverageCrit=0
	if Stats["MultiCrit"]>0:
		for ii:int in range(1,Stats["MultiCrit"]):
			AverageCrit+=ii*Stats["CritChance"]*(Stats["CritChance"]/Stats["MultiCrit"])**(ii-1)*(1-Stats["CritChance"]/Stats["MultiCrit"])
		AverageCrit+=Stats["MultiCrit"]*Stats["CritChance"]*(Stats["CritChance"]/Stats["MultiCrit"])**(Stats["MultiCrit"])
	else:
		AverageCrit=Stats["CritChance"]
	find_child("Average").find_child("DPS").text=GlobalFunctions.SIRound(Stats["AttackDamage"]*Stats["AttackSpeed"]*(Stats["Multihit"]+1)*((1-Stats["CritChance"])+Stats["CritDamage"]*AverageCrit))
	find_child("Average").find_child("DPR").text=GlobalFunctions.SIRound(Stats["AttackDamage"]*Stats["AttackSpeed"]*(Stats["Multihit"]+1)*((1-Stats["CritChance"])+Stats["CritDamage"]*AverageCrit))
