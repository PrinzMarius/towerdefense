extends Node
signal tower_transfer(TransferTower:PackedScene)
signal player_damage(Damage:int)
signal round_end(Round:int)
signal towerstat_changed(Name:String,value:float)
signal tower_selected(SelectionTower:CharacterBody3D)

func _ready()->void:
	PlayerValues.playerdamage.connect(_emit_playerdamage)

func _emit_tower(EmitTower:PackedScene)->void:
	tower_transfer.emit(EmitTower)

func _emit_playerdamage(Damage:int)->void:
	player_damage.emit(Damage)

func _emit_round_end(RoundNumber:int)->void:
	round_end.emit(RoundNumber)

func _emit_towerstat_changed(Name:String,value:float)->void:
	towerstat_changed.emit(Name,value)

func _emit_tower_selected(SelectionTower:CharacterBody3D)->void:
	tower_selected.emit(SelectionTower)
