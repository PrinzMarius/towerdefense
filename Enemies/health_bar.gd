extends TextureProgressBar

func _update_bar(new_val:int)->void:
	var tween:Tween=create_tween()
	tween.tween_property(self, "value", new_val, 0.25)


func _move_damage_text(text:Label)->void:
	var tween:Tween=create_tween().set_parallel(true)
	tween.set_trans(Tween.TRANS_QUART)
	tween.tween_property(text,"position:x",text.position.x+size.x-text.size.x*2,1)
	tween.tween_property(text,"modulate",Color(1,1,1,0),1)
