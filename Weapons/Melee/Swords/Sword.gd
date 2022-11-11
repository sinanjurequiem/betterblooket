extends SlashingWeapon

var weapon_up = true


func _attack() -> void:
	if not animation_player.is_playing():
		if weapon_up:
			animation_player.play("slashdown")
			weapon_up = false
		elif not weapon_up:
			animation_player.play("slashup")
			weapon_up = true
			print("slashup")
