extends CanvasLayer

const MIN_HEALTH: int = 0
const MAX_HEALTH: int = 100

var max_hp: int = 4

onready var player: KinematicBody2D = get_parent().get_node("Player")
onready var health_bar = $HealthBar
onready var health_bar_tween = $HealthBar/Tween
onready var health_bar_label = $HealthBar/Label

func _ready() -> void:
	max_hp = player.hp

func _process(delta) -> void:
	if is_instance_valid(player):
		health_bar_label.text = str(player.hp) + "/" + str(max_hp)
	else:
		queue_free()

func update_health_bar(new_value: int) -> void:
	var __ = $HealthBar/Tween.interpolate_property(health_bar, "value", $HealthBar.value, new_value, 0.5, Tween.TRANS_CUBIC, Tween.EASE_OUT) #long ass code
	__ = $HealthBar/Tween.start()

func _on_Player_hp_changed(new_hp):
	var new_health: int = int((MAX_HEALTH-MIN_HEALTH)*float(new_hp)/max_hp) + MIN_HEALTH
	update_health_bar(new_health)
	#update_health_bar(new_hp)
	print("damaged signal recieved")
