extends Character
class_name Enemy, "res://Textures (placeholder)/enemies/slime/slime_idle_anim_f0.png"

var path: PoolVector2Array

export var speed := 1

#navigation
export var path_to_player: NodePath = NodePath()
onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
onready var navigation: Navigation2D = get_parent()
onready var player: KinematicBody2D = get_tree().current_scene.get_node("Player")
onready var path_timer: Timer = $"PathTimer"


func _ready() -> void:
	if is_instance_valid(player):
		print("valid instance")
	var __ = connect("tree_exited", get_parent(), "_on_enemy_killed")

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
	if is_instance_valid(player):
		path = navigation.get_simple_path(global_position, player.position) #deprecated soon
	else:
		path_timer.stop()
		path = []
		direction = Vector2(0,0)


