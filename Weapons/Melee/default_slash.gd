extends Weapon
class_name SlashingWeapon, "res://Textures/Weapons/BaseSword.png"

export var stages: int = 1
export var combo: int = 1

export var damagetype:= "default" # can be set to default, fire, poison, ice, electric

onready var effect = $"Effect"
onready var animation_player = $"AnimationPlayer"

