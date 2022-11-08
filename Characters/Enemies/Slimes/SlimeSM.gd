extends StateMachine

func _init() -> void:
	_add_state("idle")
	_add_state("chase")
	_add_state("attack")
	_add_state("alert")
	_add_state("hurt")
	_add_state("dead")

func _ready() -> void:
	set_state(states.idle)
	animation_player.play("RESET")



func _state_logic(_delta: float) -> void:
	if state == states.chase:
		parent.chase()
		parent.move()
	elif state == states.alert:
		animation_player.play("alert")
		yield(get_tree().create_timer(0.25), "timeout")
		set_state(states.chase)
	elif state == states.idle:
		if not animation_player.is_playing():
			animation_player.play("idle")
	elif state == states.hurt:
		animation_player.play("hurt")
		yield(get_tree().create_timer(0.25), "timeout")
		set_state(states.chase)
	elif state == states.dead:
		animation_player.play("death")
		yield(get_tree().create_timer(0.8), "timeout")
		queue_free()

func _get_transition(delta):
	match state:
		states.hurt:
			if not animation_player.is_playing():
				return states.chase

func _enter_state(new_state, old_state):
	match new_state:
		states.chase:
			if not animation_player.is_playing():
				animation_player.play("run")
		states.idle:
			if not animation_player.is_playing():
				animation_player.play("idle")
		states.hurt:
			if not animation_player.is_playing():
				animation_player.play("hurt")

func _on_PlayerDetected(body):
	if body.name == "Player" and state == states.idle:
		set_state(states.alert)





func _on_PlayerDetection_body_exited(body):
	if body.name == "Player" and state == states.chase:
		set_state(states.idle)
