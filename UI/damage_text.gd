extends Sprite3D

@onready var TextLabel:Label=$DamageTextViewPort/DamageText2D
func _ready() -> void:
	offset.x-=80
func _physics_process(_delta: float) -> void:
	offset.x+=4
	transparency+=0.02
