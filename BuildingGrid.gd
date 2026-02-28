extends Node3D

var GridSize:float=2.5
var MousePosition:Vector2
var clickLocation: Vector3
var buildModeOn:bool
var ActiveBuildTower:PackedScene
var FloatTower:Node3D
var SavedAlbedo:Color
var BuildIllegal:bool=false
var BuildAreaBlock:bool=false
var BuildCollisionBlock:bool=false
@export var IllegalAreaParent: CSGBox3D
@export var View: Camera3D
signal TowerBuilt(NewTower:PackedScene,Location:Vector3)

func _ready() -> void:
	SignalBus.tower_transfer.connect(_build_mode_start)

func _physics_process(_delta: float) -> void:
	if buildModeOn:
		FloatTower.global_position=round(GlobalFunctions.get_object_under_mouse(View,get_parent()).position/GridSize)*Vector3(GridSize,0,GridSize)+Vector3(2.5,10,2.5)
		for CheckArea:CSGBox3D in IllegalAreaParent.find_children("*","CSGBox3D"):
			var PointQuery:Vector3=FloatTower.global_position
			var CheckXm:float=CheckArea.global_position.x-CheckArea.size.x/2-GridSize
			var CheckXp:float=CheckArea.global_position.x+CheckArea.size.x/2+GridSize
			var CheckYm:float=CheckArea.global_position.y-CheckArea.size.y/2-GridSize
			var CheckYp:float=CheckArea.global_position.y+CheckArea.size.y/2+GridSize
			if PointQuery.x>CheckXm and PointQuery.x<CheckXp and PointQuery.y>CheckYm and PointQuery.y<CheckYp:
				BuildAreaBlock=true
			else:
				BuildAreaBlock=false
		if BuildAreaBlock or BuildCollisionBlock:
			for Recolor:MeshInstance3D in FloatTower.find_children("*","MeshInstance3D"):
				Recolor.get_mesh().get_material().albedo_color=Color.RED-Color(0,0,0,0.5)
			BuildIllegal=true
		else:
			for Recolor:MeshInstance3D in FloatTower.find_children("*","MeshInstance3D"):
				Recolor.get_mesh().get_material().albedo_color=Color.BLUE-Color(0,0,0,0.5)
			BuildIllegal=false
	

			
func _input(event: InputEvent) -> void:
	if BuildIllegal==false and buildModeOn:
		if event.is_action_pressed("click_left"):
			var buildLocation:Vector3 = FloatTower.global_position
			TowerBuilt.emit(ActiveBuildTower,buildLocation)
			buildModeOn=false
			FloatTower.queue_free()
		elif event.is_action_pressed("click_right"):
			buildModeOn=false
			FloatTower.queue_free()
	
func _build_mode_start(Tower:PackedScene) -> void:
	buildModeOn=true
	ActiveBuildTower=Tower
	FloatTower=ActiveBuildTower.instantiate()
	add_sibling(FloatTower)
	FloatTower.BuildCollisionArea.body_shape_entered.connect(_build_collision_started)
	FloatTower.BuildCollisionArea.body_shape_exited.connect(_build_collision_ended)

func _build_collision_started(_body_rid: RID, body: CharacterBody3D, _body_shape_index: int, _local_shape_index: int)->void:
	if body!=FloatTower:
		BuildCollisionBlock=true

func _build_collision_ended(_body_rid: RID, _body: CharacterBody3D, _body_shape_index: int, _local_shape_index: int)->void:
	BuildCollisionBlock=false
