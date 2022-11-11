extends Character


onready var weapon = $"Weapon"
onready var weapon_hitbox = $"Weapon/Pivot Point/Sprite/Hitbox"
onready var weapon_animation_player = weapon.get_node("AnimationPlayer") #fix this later to work with other weapons
onready var ui = $UI


var weapon_up:bool = true #placeholder


signal main_attack

func _ready():
	connect("main_attack", get_node("Weapon"), "_attack")
	connect("hp_changed", get_node("UI"), "on_Player_hp_changed")
	emit_signal("hp_changed", hp)

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
	
	var mouse_direction: Vector2 = (get_global_mouse_position() - global_position).normalized()
	
	if not weapon_animation_player.is_playing():
		weapon_hitbox.knockback_direction = mouse_direction
		weapon.rotation = mouse_direction.angle()
		if weapon.scale.y == 1 and mouse_direction.x < 0:
			weapon.scale.y = -1
		elif weapon.scale.y == -1 and mouse_direction.x > 0:
			weapon.scale.y = 1
	
	if Input.is_action_pressed("ui_attack_main"):
		emit_signal("main_attack")


func _on_question_answerable() -> void:
#	var question: PackedScene = preload("res://QA/quiz_screen.tscn")
#	var question_instance = question.instance()
#	ui.add_child(question_instance)
	print("question_answerable")

