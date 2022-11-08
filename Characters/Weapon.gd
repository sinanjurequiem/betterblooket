extends Node2D
class_name Weapon

#idk what to put here

signal attack

func _on_Player_main_attack():
	emit_signal("attack")
