extends KinematicBody2D

class_name Character, "res://Textures (placeholder)/heroes/knight/knight_idle_anim_f0.png"

const friction = 0.15
export var acceleration:= 40
export var max_speed:= 100

#onready var animated_sprite := $"AnimatedSprite"


var direction := Vector2.ZERO
var velocity := Vector2.ZERO

func _physics_process(_delta: float) -> void:
	velocity = move_and_slide(velocity)
	velocity = lerp(velocity, Vector2.ZERO, friction)


func move() -> void:
	direction = direction.normalized()
	velocity += direction * acceleration
	velocity = velocity.clamped(max_speed)
	
