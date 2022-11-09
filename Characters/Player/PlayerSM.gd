extends StateMachine

func _init():
	_add_state("idle")
	_add_state("run")
	_add_state("hurt")
	_add_state("dead")


func _ready():
	set_state(states.idle)


func _state_logic(delta):
	if state == states.idle or state == states.run:
		parent.get_input()
		parent.move()

func _get_transition(delta):
	match state:
		states.idle:
			if parent.velocity.length() > 10:
				return states.run
		states.run:
			if parent.velocity.length() < 10:
				return states.idle
		states.hurt:
			if not animation_player.is_playing():
				return states.idle

func _enter_state(new_state, old_state):
	match new_state:
		states.idle:
			animation_player.play("idle")
		states.run:
			animation_player.play("run")
		states.hurt:
			animation_player.play("hurt")
			yield(get_tree().create_timer(0.3), "timeout")
		states.dead:
			animation_player.play("death")
			yield(get_tree().create_timer(0.8), "timeout")
			parent.queue_free()


			

func _exit_state(old_state, new_state):
	pass

