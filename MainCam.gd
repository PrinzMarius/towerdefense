extends Node3D
@export var CameraSpeed: int
@export var Camera:Camera3D
@onready var BaseSize:float=Camera.size
@onready var BaseTransformationCam:Transform3D=Camera.global_transform
@onready var BaseTransformationNode:Vector3=rotation

func _input(CamInput: InputEvent) -> void:
	if CamInput.is_action_pressed("key_down"):
		global_position.z-=CameraSpeed
	elif CamInput.is_action_pressed("key_up"):
		global_position.z+=CameraSpeed
	elif CamInput.is_action_pressed("key_left"):
		global_position.x+=CameraSpeed
	elif CamInput.is_action_pressed("key_right"):
		global_position.x-=CameraSpeed
	elif CamInput.is_action_pressed("scroll_down"):
		Camera.size+=CameraSpeed
	elif CamInput.is_action_pressed("scroll_up"):
		Camera.size-=CameraSpeed
	elif CamInput.is_action_pressed("rotate_cam_left"):
		rotation.y-=PI/4
	elif CamInput.is_action_pressed("rotate_cam_right"):
		rotation.y+=PI/4
	elif CamInput.is_action_pressed("reset"):
		Camera.size=BaseSize
		global_transform=BaseTransformationCam
		rotation=BaseTransformationNode
