extends GridContainer
var AverageCrit:float=0
var Stats:Dictionary={
	"Inspiration":{"value":0,"Tooltip":"Increases the chance to draw enhancements by %s %%."},
	"Creativity":{"value":0,"Tooltip":"Increases the chance to draw higher rarity enhancements by %s %%."},
	"Consistency":{"value":0,"Tooltip":"Chance based passive,spell and item effects have a %s %% better outcome."},
	"Yield":{"value":0,"Tooltip":"Gains %s %% more graphite from enemies."},
	"Dilligence":{"value":0,"Tooltip":"Increases score gained by %s %%."},
}
var Score:float=0
var ScoreUp:float=0
var GradeList:Array[String]=["F","E-","E","E+","D-","D","D+","C-","C","C+","B-","B","B+","A-","A","A+","A++","G"]
func _ready() -> void:
	SignalBus.towerstat_changed.connect(_update_Label)
func _update_Label(Name:String,value:float)->void:
	if Name=="Score":
		Score=value
		find_child(Name).text=str(value)+"/"+str(ScoreUp)
		return
	if Name=="ScoreUp":
		ScoreUp=value
		find_child("Score").text=str(Score)+"/"+str(value)
		return
	if Name=="Grade":
		find_child(Name).text=GradeList[value-1]
		if GradeList[value-1]=="G":
			find_child(Name).tooltip_text="Tower graduated. It can no longer increase its score."
		else:
			find_child(Name).tooltip_text="Current grade of the Tower. Gain a higher score to get a higher grade."
		return
	if Name in Stats:
		Stats[Name]["value"]=value
	else:
		return
	if find_children(Name).is_empty()==false:
		find_child(Name,true).text=GlobalFunctions.SIRound(value)
		find_child(Name+"Grid",true).tooltip_text=Stats[Name]["Tooltip"] % GlobalFunctions.SIRound(value)
