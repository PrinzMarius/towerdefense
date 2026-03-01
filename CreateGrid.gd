extends Node2D
var MainLineTex:GradientTexture2D
var SubLineTex:GradientTexture2D
var GridLine:Line2D
func _ready()->void:
	var GridX:int=ceili(256/5)
	SubLineTex=_create_dash_texture(Color.DIM_GRAY-Color(0,0,0,0.5))
	for ii:int in range(1,GridX):
		GridLine=_create_dashed_Line(2,Vector2(get_parent().size.x,ii*5+1),Vector2(0,ii*5+1),10,null)
		GridLine.default_color=Color.BLACK-Color(0,0,0,0.25)
		add_child(GridLine)
		GridLine=_create_dashed_Line(1,Vector2(get_parent().size.x,ii*5+2.5+1),Vector2(0,ii*5+1+2.5),10,SubLineTex)
		add_child(GridLine)
		#Y-Lines
		GridLine=_create_dashed_Line(2,Vector2(ii*5+1,get_parent().size.y),Vector2(ii*5+1,0),10,null)
		GridLine.default_color=Color.BLACK-Color(0,0,0,0.25)
		add_child(GridLine)
		GridLine=_create_dashed_Line(1,Vector2(ii*5+1+2.5,get_parent().size.y),Vector2(ii*5+1+2.5,0),10,SubLineTex)
		add_child(GridLine)
	hide()

func _create_dash_texture(color:Color)->GradientTexture2D:
	var DashTex:GradientTexture2D=GradientTexture2D.new()
	var DashGradient:Gradient=Gradient.new()
	DashGradient.set_offset(0,0)
	DashGradient.set_offset(1,0.5)
	DashGradient.set_color(0,color)
	DashGradient.set_color(1,Color.TRANSPARENT)
	DashGradient.interpolation_mode=Gradient.GRADIENT_INTERPOLATE_CONSTANT
	DashTex.gradient=DashGradient
	DashTex.width=125
	DashTex.height=10
	DashTex.fill=GradientTexture2D.FILL_LINEAR
	DashTex.fill_from=Vector2(0,0)
	DashTex.fill_to=Vector2(1,0)
	DashTex.repeat=GradientTexture2D.REPEAT
	return DashTex

func _create_dashed_Line(width:float,from:Vector2,to:Vector2,scaling:float,texture:Texture2D)->Line2D:
	var new_Line:Line2D	
	new_Line=Line2D.new()
	new_Line.width=width
	new_Line.add_point(from*scaling)
	new_Line.add_point(to*scaling)
	new_Line.texture=texture
	new_Line.texture_mode=Line2D.LINE_TEXTURE_TILE
	new_Line.texture_repeat=CanvasItem.TEXTURE_REPEAT_ENABLED
	return new_Line
