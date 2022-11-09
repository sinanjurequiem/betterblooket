extends SlashingWeapon

var weapon_up = true
onready var parent = get_parent()

func _attack() -> void:
	animation_player = $AnimationPlayer
	if weapon_up:
		animation_player.play("slashdown")
		weapon_up = false
		print("slashdown")
	elif not weapon_up:
		animation_player.play("slashup")
		weapon_up = true
		print("slashup")
	print("signal received")
