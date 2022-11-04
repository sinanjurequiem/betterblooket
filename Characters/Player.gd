extends Character

onready var animated_sprite = $"AnimatedSprite"
onready var weapon = $"Weapon"
onready var weapon_animation_player = $"Weapon/Sword/AnimationPlayer" #fix this later to work with other weapons

signal main_attack

func _process(delta):
	var mouse_direction: Vector2 = (get_global_mouse_position() - global_position).normalized()
	
	if mouse_direction.x > 0 and animated_sprite.flip_h:
		animated_sprite.flip_h = false
	elif mouse_direction.x < 0 and not animated_sprite.flip_h:
		animated_sprite.flip_h = true
	
	weapon.rotation = mouse_direction.angle()
	if weapon.scale.y == 1 and mouse_direction.x < 0:
		weapon.scale.y = -1
	elif weapon.scale.y == -1 and mouse_direction.x > 0:
		weapon.scale.y = 1
	
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
	if Input.is_action_pressed("ui_attack_main"):
		emit_signal("main_attack")


func _on_Weapon_attack():
	pass # Replace with function body.
