extends StaticBody2D

onready var animation_player := $AnimationPlayer

func open():
	animation_player.play("open")
