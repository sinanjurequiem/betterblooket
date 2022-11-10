extends Node2D

const SPAWN_EXPLOSION_SCENE: PackedScene = preload("res://Scenes/Misc/SpawnExplosion.tscn")
const ENEMY_SCENES: Dictionary = {
	"BASE_SLIME":preload("res://Characters/Enemies/Slimes/Base Slime/BaseSlime.tscn")
	# add more enemies later
}

var num_enemies: int

onready var tilemap: TileMap = $TileMap2
onready var entrance: Node2D = $Entrance
onready var door_container: Node2D = $Doors
onready var enemy_positions_container: Node2D = $EnemyPositions
onready var player_detector: Area2D = $PlayerDetector

func _ready() -> void:
	num_enemies = enemy_positions_container.get_child_count()

func open_doors() -> void:
	for door in door_container.get_children():
		door.open()
		print("door command recieved")

func _close_entrance() -> void:
	for entry_position in entrance.get_children():
		tilemap.set_cellv(tilemap.world_to_map(entry_position.global_position), 1)
		tilemap.set_cellv(tilemap.world_to_map(entry_position.global_position) + Vector2.DOWN, 2)
		print("room closed")

func _spawn_enemies() -> void:
	for enemy_position in enemy_positions_container.get_children():
		var enemy: KinematicBody2D = ENEMY_SCENES.BASE_SLIME.instance()
		var __ = enemy.connect("tree_exited", self, "_on_enemy_killed")
		enemy.position = enemy_position.position
		call_deferred("add_child", enemy)
		
		var spawn_explosion: AnimatedSprite = SPAWN_EXPLOSION_SCENE.instance()
		spawn_explosion.position = enemy_position.position
		call_deferred("add_child", spawn_explosion)
	print(str(num_enemies) + " spawned")

func _on_enemy_killed() -> void:
	num_enemies -= 1
	print(num_enemies)
	yield(get_tree().create_timer(0.01), "timeout")
	if num_enemies == 0:
		open_doors()
		print("door command sent")


func _on_PlayerDetected(body: KinematicBody2D):
	if body is Character: #works *for now*
		player_detector.queue_free()
		_close_entrance()
		_spawn_enemies()
