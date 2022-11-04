extends Node2D

#idk what to put here

signal attack



func _on_Player_main_attack():
	emit_signal("attack")
