extends Control



func _on_X_pressed():
	queue_free()

func _ready():
	var files = list_files("res://Sets/")
	if files == []:
		print("bruh you have no quiz sets :skull:")
	else:
		print(files)

func list_files(path):
	var files = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()
	
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			files.append(file)
	
	dir.list_dir_end()
	
	return files

func read_file(file_path):
	var file = File.new()
	file.open(file_path, File.READ)
	var content_as_text = file.get_as_text
	var content_as_dictionary = parse_json(content_as_text)
	return content_as_dictionary
