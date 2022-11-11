extends StaticBody2D

onready var animation_player := $AnimationPlayer
onready var player_detector := $PlayerDetector
onready var player_detector_hitbox := $PlayerDetector/CollisionShape2D

func open():
	animation_player.play("open")
	player_detector_hitbox.disabled = false
	
	# add question functionality later
	#player_detector.connect("body_entered", get_parent().get_parent().get_node("Player"), "_on_question_answerable")
	#print("connected")

