extends StateMachine

func _init() -> void:
	_add_state("idle")
	_add_state("chase")
	_add_state("attack")
	_add_state("alert")

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

func _get_transition(delta):
	return null

func _enter_state(new_state, old_state):
	match new_state:
		states.chase:
			if not animation_player.is_playing():
				animation_player.play("run")
		states.idle:
			if not animation_player.is_playing():
				animation_player.play("idle")

func _on_PlayerDetected(body):
	if body.name == "Player" and state == states.idle:
		set_state(states.alert)


