extends SlashingWeapon

var weapon_up = true

func _process(delta) -> void:
	get_input()

func get_input() -> void:
	if Input.is_action_pressed("ui_attack_main") and not animation_player.is_playing():
		#emit_signal("main_attack")
		if weapon_up:
			animation_player.play("slashdown")
			weapon_up = false
			print("slashdown")
		elif not weapon_up:
			animation_player.play("slashup")
			weapon_up = true
			print("slashup")
