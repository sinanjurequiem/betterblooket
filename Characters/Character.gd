extends KinematicBody2D

class_name Character, "res://Textures (placeholder)/heroes/knight/knight_idle_anim_f0.png"

export var hp := 2

const friction = 0.15
export var acceleration:= 40
export var max_speed:= 100

onready var state_machine = get_node("StateMachine")

onready var animated_sprite := $"AnimatedSprite"
onready var animation_player := $"AnimationPlayer"


var direction := Vector2.ZERO
var velocity := Vector2.ZERO

func _physics_process(_delta: float) -> void:
	velocity = move_and_slide(velocity)
	velocity = lerp(velocity, Vector2.ZERO, friction)



func move() -> void:
	direction = direction.normalized()
	velocity += direction * acceleration
	velocity = velocity.clamped(max_speed)

func take_damage(damage: int, direction: Vector2, force: int) -> void:
	hp -= damage
	if hp > 0:
		state_machine.set_state(state_machine.states.hurt)
		velocity += direction * force
		flash()
	else:
		state_machine.set_state(state_machine.states.dead)
		velocity += direction * force * 2
	
func flash() -> void:
	animated_sprite.material.set_shader_param("flash_modifier", 1)
	yield(get_tree().create_timer(0.2), "timeout")
	animated_sprite.material.set_shader_param("flash_modifier", 0)
