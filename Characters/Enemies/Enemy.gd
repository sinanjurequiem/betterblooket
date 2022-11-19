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

#pathfinding
export var steer_force = 0.1
export var look_ahead = 100
export var num_rays = 32

# context array
var ray_directions = []
var interest = []
var danger = []

var chosen_dir = Vector2.ZERO


func _ready() -> void:
	if is_instance_valid(player):
		print("valid instance")
	var __ = connect("tree_exited", get_parent(), "_on_enemy_killed")

	var raycast_degrees = 360/num_rays
	var current_degrees = 0

	interest.resize(num_rays)
	danger.resize(num_rays)
	ray_directions.resize(num_rays)
	for i in num_rays:
		var raycast = RayCast2D.new()
		raycast.rotation_degrees = current_degrees
		current_degrees += raycast_degrees
		self.call_deferred("add_child", raycast)
		var angle = i * 2 * PI / num_rays
		ray_directions[i] = Vector2.RIGHT.rotated(angle)

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

func _physics_process(delta: float) -> void:
	#velocity = move_and_slide(velocity)
	#move_and_collide(velocity * delta)
	#velocity = lerp(velocity, Vector2.ZERO, friction)
	set_interest()
	set_danger()
	choose_direction()
	var desired_velocity = chosen_dir.rotated(rotation) * max_speed
	velocity = velocity.linear_interpolate(desired_velocity, steer_force)
	rotation = velocity.angle()
	move_and_collide(velocity * delta)

func set_interest():
	# Set interest in each slot based on world direction
	if owner and owner.has_method("get_path_direction"):
		var path_direction = owner.get_path_direction(position)
		for i in num_rays:
			var d = ray_directions[i].rotated(rotation).dot(path_direction)
			interest[i] = max(0, d)
	# If no world path, use default interest
	else:
		set_default_interest()

func set_default_interest():
	# Default to moving forward
	for i in num_rays:
		var d = ray_directions[i].rotated(rotation).dot(transform.x)
		interest[i] = max(0, d)

func set_danger():
	# Cast rays to find danger directions
	var space_state = get_world_2d().direct_space_state
	for i in num_rays:
		var result = space_state.intersect_ray(position,
				position + ray_directions[i].rotated(rotation) * look_ahead,
				[self])
		danger[i] = 1.0 if result else 0.0

func choose_direction():
	# Eliminate interest in slots with danger
	for i in num_rays:
		if danger[i] > 0.0:
			interest[i] = 0.0
	# Choose direction based on remaining interest
	chosen_dir = Vector2.ZERO
	for i in num_rays:
		chosen_dir += ray_directions[i] * interest[i]
	chosen_dir = chosen_dir.normalized()

