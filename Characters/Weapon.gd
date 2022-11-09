extends Node2D
class_name Weapon

#idk what to put here

export var damage: int = 1
export var knockback : int = 300
var knockback_direction : Vector2 = Vector2.ZERO
var parent = get_parent()

signal attack

func _on_Player_main_attack():
	emit_signal("attack")

