extends Area2D
class_name Hitbox

export (int) var damage: int = 1
export (int) var knockback: int = 300

var knockback_direction: Vector2 = Vector2.ZERO

onready var collision_shape: CollisionShape2D = get_child(0)

func _init() -> void:
	connect("body_entered", self, "_on_body_entered")

func _ready() -> void:
	assert(collision_shape != null)

func _on_body_entered(body: PhysicsBody2D) -> void:
	print(body)
	if body is KinematicBody2D:
		body.take_damage(damage, knockback_direction, knockback)
		print(body)
	else:
		pass
