extends StateMachine

func _init():
	_add_state("idle")
	_add_state("run")

func _ready():
	set_state(states.idle)


func _state_logic(delta):
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

func _enter_state(new_state, old_state):
	match new_state:
		states.idle:
			animation_player.play("idle")
		states.run:
			animation_player.play("run")

func _exit_state(old_state, new_state):
	pass

