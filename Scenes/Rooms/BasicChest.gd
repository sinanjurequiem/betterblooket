extends StaticBody2D
class_name Chest

onready var animation_player = $AnimationPlayer

func open() -> void:
	animation_player.play("open")

# add spawn stuff later
