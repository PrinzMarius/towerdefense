extends Control
@export var Name1Grid: GridContainer
@export var Value1Grid: GridContainer
@export var Name2Grid: GridContainer
@export var Value2Grid:GridContainer
@export var Name3Grid: GridContainer
@export var Value3Grid:GridContainer
@export var LabelScene: PackedScene
@export var Background: Sprite2D
@onready var StatText:String=""
var NameGrid: GridContainer
var ValueGrid: GridContainer
var DoubleDotGrid: GridContainer
var Absatz:int=1
var NameLabel: Label
var ValueLabel: Label
var DoubleDotLabel: Label
var LoopCounter:int=1
var CompName: String
var PP_names: Array
var CompValue: Label
var DPSLineAnchor1:Label
var DPSLineAnchor2:Label
var DPSSeperator: Line2D
func _ready() -> void:
	visible=false

func write_tower_stats()->void:
	await Engine.get_main_loop().process_frame
	for propertyInfos:Dictionary in get_parent().get_script().get_script_property_list():
		if propertyInfos.name != "TimeCounter" and propertyInfos.name!="DPRCalculator" and propertyInfos.name!="DPSCalculator" and propertyInfos.name!="AttackCooldown" and propertyInfos.name!="MaxLevel" and propertyInfos.name!="BaseEXP" and propertyInfos.name!="MissleSpeed":
			if get_parent().get(propertyInfos.name) is float || get_parent().get(propertyInfos.name) is int:
				if str(propertyInfos.name) =="SpellDamage" or str(propertyInfos.name) =="DPS" :
					Absatz+=1
				NameGrid=get(str("Name",Absatz,"Grid"))
				ValueGrid=get(str("Value",Absatz,"Grid"))
				NameLabel=LabelScene.instantiate()
				NameGrid.add_child(NameLabel)
				var NameArray:Array=str(propertyInfos.name).split()
				for ii:int in range(1,NameArray.size()):
					if NameArray[ii]==NameArray[ii].to_upper() and NameArray[ii-1]!=NameArray[ii-1].to_upper():
						NameArray[ii]=str(" "+NameArray[ii])
				NameLabel.text="".join(NameArray)
				ValueLabel=LabelScene.instantiate()
				ValueGrid.add_child(ValueLabel)
				ValueLabel.horizontal_alignment=HORIZONTAL_ALIGNMENT_RIGHT
				ValueLabel.text=GlobalFunctions.SIRound(get_parent().get(propertyInfos.name))
				if str(propertyInfos.name) =="CritChance" or str(propertyInfos.name) =="AttackDamageMultiplicator" or str(propertyInfos.name) =="CrtiDamage":
					NameLabel.text=str(NameLabel.text,"[%]")
				if str(propertyInfos.name) =="AttackDPS":
					await Engine.get_main_loop().process_frame
					DPSSeperator=Line2D.new()
					add_child(DPSSeperator)
					DPSLineAnchor1=NameLabel
					DPSLineAnchor2=ValueLabel
					DPSSeperator.add_point(DPSLineAnchor1.global_position-global_position)
					DPSSeperator.add_point(DPSLineAnchor2.global_position-global_position+Vector2(DPSLineAnchor2.size.x,0))
					DPSSeperator.width=2
					DPSSeperator.default_color=Color.BLACK
	await Engine.get_main_loop().process_frame
	global_position.x=global_position.x-size.x
	Background.texture.width=$GridContainer2.size.x
	Background.texture.height=$GridContainer2.size.y
	Background.position=$GridContainer2.position+Vector2($GridContainer2.size.x,$GridContainer2.size.y)/2

func _process(_delta: float) -> void:
	if visible:
		PP_names=[]
		for PropInfos:Dictionary in get_parent().get_script().get_script_property_list():
			PP_names.append(PropInfos.name)
		for CompNames:Label in find_children("*","Label",true,false):
			if PP_names.has(CompNames.text.replace(" ","").replace("[%]","")):
				CompValue=CompNames.get_parent().get_parent().get_child(1).get_child(CompNames.get_index())
				CompValue.text=str(GlobalFunctions.SIRound(get_parent().get(CompNames.text.replace(" ","").replace("[%]",""))))
				if get_parent().get(CompNames.text.replace(" ","").replace("[%]",""))<100 and CompNames.text!="Attack Speed" and CompNames.text!="Base Attack Speed" and CompNames.text!="Ressource Generation":
					CompValue.text=CompValue.text.split(".")[0].replace(" ","")+" "
		if DPSSeperator!=null:
			DPSSeperator.points[0]=(DPSLineAnchor1.global_position-global_position)
			DPSSeperator.points[1]=(DPSLineAnchor2.global_position-global_position+Vector2(DPSLineAnchor2.size.x,0))
