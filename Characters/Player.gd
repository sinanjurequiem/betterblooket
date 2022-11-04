extends Character

onready var animated_sprite = $"AnimatedSprite"

func _process(delta):
	var mouse_direction: Vector2 = (get_global_mouse_position() - global_position).normalized()
	
	if mouse_direction.x > 0 and animated_sprite.flip_h:
		animated_sprite.flip_h = false
	elif mouse_direction.x < 0 and not animated_sprite.flip_h:
		animated_sprite.flip_h = true
	
	get_input()

func get_input():
	direction = Vector2.ZERO
	if Input.is_action_pressed("ui_down"):
		direction+= Vector2.DOWN
	if Input.is_action_pressed("ui_up"):
		direction+= Vector2.UP
	if Input.is_action_pressed("ui_right"):
		direction+= Vector2.RIGHT
	if Input.is_action_pressed("ui_left"):
		direction+= Vector2.LEFT

