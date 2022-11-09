extends Enemy

onready var hitbox: Area2D = get_node("Hitbox")

func _process(delta) -> void:
	hitbox.knockback_direction = velocity.normalized()
