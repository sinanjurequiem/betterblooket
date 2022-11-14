extends Node

onready var loading_scene = preload("res://Scenes/Misc/loading_screen.tscn")

func _load_scene(current_scene, next_scene) -> void:
	var loading_scene_instance = loading_scene.instance()

	get_tree().get_root().call_deferred("add_child",loading_scene_instance)
	
	var loader = ResourceLoader.load_interactive(next_scene)
	
	if loader == null:
		print("an error occurred while getting the scene. check the file path and/or code")
		return
	
	current_scene.queue_free()
	
	yield(get_tree().create_timer(0.5), "timeout")
	
	while true:
		var error = loader.poll()
		if error == OK:
			var progress_bar = loading_scene_instance.get_node("ColorRect/CenterContainer/VBoxContainer/TextureProgress")
			progress_bar.value = float(loader.get_stage())/loader.get_stage_count() * 100
		
		elif error == ERR_FILE_EOF:
			var scene = loader.get_resource().instance()
			
			get_tree().get_root().call_deferred("add_child",scene)
			
			loading_scene_instance.queue_free()
			return
		
		else:
			print("error occurred while loading chonks of data")
			return
		
		yield(get_tree().create_timer(0.5), "timeout")
