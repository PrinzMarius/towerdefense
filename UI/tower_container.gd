extends VBoxContainer
var expand_time:float=0.25
var flapout:bool=false
@export var TowerTabs:TabContainer
func _ready() -> void:
	TowerTabs.tab_clicked.connect(_tab_flapout)

func _tab_flapout(tab:int)->void:
	if flapout:
		if tab==TowerTabs.get_previous_tab():
			flapout=false
			var tween:Tween = create_tween()
			tween.tween_property(self, "global_position:x", global_position.x-TowerTabs.size.y+36, expand_time)
	else:
		flapout=true
		var tween:Tween = create_tween()
		tween.tween_property(self, "global_position:x", global_position.x+TowerTabs.size.y-36, expand_time)
