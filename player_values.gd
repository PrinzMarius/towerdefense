extends Node

var Graphite:int=0
var Skillpoint:int=0:
	set(value):
		skillpoint_changed.emit(value,Skillpoint)
		Skillpoint=value

var PlayerHP:int=100:
	set(value):
		playerdamage.emit(PlayerHP-value)
		PlayerHP=value

var SubjectDict:Dictionary={
							"History":0,
							"Physics":0}

signal playerdamage(value:int)
signal skillpoint_changed(value:int,previousvalue:int)

enum knowledge{HISTORY,PHYSICS}
enum type{GRAPHITE,SKILLPOINT,PLAYERHP}

func allocate_classpoint(subj:knowledge,value:int)->void:
	SubjectDict[knowledge.keys()[subj]]+=value

func change_player_value(Name:type,value:int)->void:
	match Name:
		type.GRAPHITE:
			Graphite+=value
		type.SKILLPOINT:
			Skillpoint+=value
		type.PLAYERHP:
			PlayerHP+=value
