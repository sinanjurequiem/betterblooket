extends KinematicBody2D

class_name Character, "res://Textures (placeholder)/heroes/knight/knight_idle_anim_f0.png"

export var hp := 2 setget set_hp
signal hp_changed(new_hp)

const friction := 0.15
export var acceleration:= 40
export var max_speed:= 100

onready var state_machine = get_node("StateMachine")

onready var animated_sprite := $"AnimatedSprite"
onready var animation_player := $"AnimationPlayer"


var direction := Vector2.ZERO
var velocity = Vector2.ZERO

func _physics_process(delta: float) -> void:
	move_and_collide(velocity*delta)
	velocity = lerp(velocity, Vector2.ZERO, friction)



func move() -> void:
	direction = direction.normalized()
	velocity += direction * acceleration
	velocity = velocity.clamped(max_speed)

func take_damage(damage: int, direction: Vector2, force: int) -> void:
	self.hp -= damage
	if hp > 0:
		state_machine.set_state(state_machine.states.hurt)
		velocity += direction * force
		flash()
	else:
		state_machine.set_state(state_machine.states.dead)
		velocity += direction * force * 2
		yield(get_tree().create_timer(0.8), "timeout")
		queue_free()

	
func flash() -> void:
	animated_sprite.material.set_shader_param("flash_modifier", 1)
	yield(get_tree().create_timer(0.2), "timeout")
	animated_sprite.material.set_shader_param("flash_modifier", 0)

func hp_changed(new_hp) -> void:
	hp = new_hp
	emit_signal("hp_changed", new_hp)


func set_hp(new_hp:int)-> void:
	hp = new_hp
	emit_signal("hp_changed", new_hp)
	
