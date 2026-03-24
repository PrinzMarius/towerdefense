extends GridContainer
var AverageCrit:float=0
var Stats:Dictionary={
	"Intensity":{"value":0,"Tooltip":"Increases a spells damage by its scaling times %s."},
	"Pool":{"value":0,"Tooltip":"For every 0.5s a Cooldown ticks down increase the next Spells damage by %s %%."},
	"Trace":{"value":0,"Tooltip":"Casts every spell %s additional times with its damage reduced by 50 %% for every cast."},
	"Flourish":{"value":0,"Tooltip":"The next attack after casting a spell deals %s %% extra damage."},
	"Cure":{"value":0,"Tooltip":"Reduces the Cooldown of all spells of this tower by %s %%."},
	"Flow":{"value":0,"Tooltip":"Every attack reduces the cooldown of all spells of this tower by %s s."}
}

func _ready() -> void:
	SignalBus.towerstat_changed.connect(_update_Label)

func _update_Label(Name:String,value:float)->void:
	if Name in Stats:
		Stats[Name]["value"]=value
	else:
		return
	if find_children(Name).is_empty()==false:
		find_child(Name,true).text=GlobalFunctions.SIRound(value)
		find_child(Name+"Grid",true).tooltip_text=Stats[Name]["Tooltip"] % GlobalFunctions.SIRound(value)
