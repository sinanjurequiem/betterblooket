extends Character
class_name Enemy, "res://Textures (placeholder)/enemies/slime/slime_idle_anim_f0.png"

var path: PoolVector2Array

export var speed := 1


onready var navigation: Navigation2D = get_tree().current_scene.get_node("Navigation2D")
onready var player: KinematicBody2D = get_tree().current_scene.get_node("Player")

func chase() -> void:
	if path:
		var vector_to_next_point := path[0] - global_position
		var distance_to_next_point := vector_to_next_point.length()
		
		if distance_to_next_point < speed:
			path.remove(0)
			if not path:
				return
		
		direction = vector_to_next_point
		
		if vector_to_next_point.x > 0 and animated_sprite.flip_h:
			animated_sprite.flip_h = false
		elif vector_to_next_point.x < 0 and not animated_sprite.flip_h:
			animated_sprite.flip_h = true

func _on_PathTimer_timeout() -> void:
	path = navigation.get_simple_path(global_position, player.position) #deprecated soon



