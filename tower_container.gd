extends TabContainer
var expand_time:float=0.25
var flapout:bool=false
func _ready() -> void:
	tab_clicked.connect(_tab_flapout)

func _tab_flapout(tab:int)->void:
	if flapout:
		if tab==get_previous_tab():
			flapout=false
			var tween:Tween = create_tween()
			tween.tween_property(self, "global_position:x", global_position.x-size.x, expand_time)
	else:
		flapout=true
		var tween:Tween = create_tween()
		tween.tween_property(self, "global_position:x", global_position.x+size.x, expand_time)
