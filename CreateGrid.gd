extends Node2D

func _ready()->void:
	var Gridsize:int=roundi(256/5)
	for ii:int in Gridsize:
		var new_Line:Line2D=Line2D.new()
		add_child(new_Line)
		new_Line.width=1
		new_Line.default_color=Color.BLACK
		new_Line.add_point(Vector2((255-(ii-1)*5+1)/0.1,get_parent().size.y/0.1))
		new_Line.add_point(Vector2((255-(ii-1)*5)/0.1,0))
