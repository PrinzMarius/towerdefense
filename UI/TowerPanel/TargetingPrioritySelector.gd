extends MenuButton
var priority_list:Array[String]=["First","Last","Highest HP","Lowest HP","Random"]
var TargetingTower: CharacterBody3D
var priority:String

func _ready() -> void:
	SignalBus.tower_selected.connect(tower_selection)
	get_popup().index_pressed.connect(_selection)

func _selection(index:int) -> void:
	TargetingTower.priority=get_popup().get_item_text(index)
	for Lists:MenuButton in get_parent().get_parent().get_parent().find_children("TargetPriority","MenuButton"):
		Lists.list_reset()
		Lists.get_popup().remove_item(priority_list.find(TargetingTower.priority))
		Lists.text=TargetingTower.priority

func tower_selection(SelectionTower:CharacterBody3D)->void:
	if SelectionTower!=TargetingTower:
		TargetingTower=SelectionTower
		list_reset()
		get_popup().remove_item(priority_list.find(TargetingTower.priority))
		text=TargetingTower.priority

func list_reset()->void:
	while get_popup().item_count>0:
		get_popup().remove_item(0)
	for strings:String in priority_list:
		get_popup().add_item(strings,priority_list.find(strings))
