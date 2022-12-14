extends Node2D

var Room = preload("res://room.tscn")
var Player = preload("res://Player.tscn")
var player = null
onready var Map = $TileMap

var tile_size = 32  # size of a tile in the TileMap
var num_rooms = 50  # number of rooms to generate
var min_size = 6  # minimum room size (in tiles)
var max_size = 10  # maximum room size (in tiles)

var hspread = 400 #horizontal spread
var vspread = 400 #vertical spread

var cull = 0.5 # chance to oof room

var play_mode = false

var path # path data

var start_room
var end_room

func _ready():
	randomize()
	make_rooms()


func make_rooms():
	for i in range(num_rooms):
		var pos = Vector2(rand_range(-hspread, hspread),rand_range(-vspread,vspread))
		var r = Room.instance()
		var w = min_size + randi()%(max_size-min_size)
		var h = min_size + randi()%(max_size-min_size)
		r.make_room(pos,Vector2(w,h)*tile_size)
		$Rooms.add_child(r)
	
	var beginning_room = Room.instance()
	beginning_room.make_room(Vector2(-1500, 0), Vector2(250,250))
	$Rooms.add_child(beginning_room)
	
	yield(get_tree().create_timer(1.1),"timeout")
	
	var room_positions = []
	for room in $Rooms.get_children():
		if randf()<cull:
			room.queue_free()
		else:
			room.mode = RigidBody2D.MODE_STATIC
			room_positions.append(Vector3(room.position.x,room.position.y,0))
	
	yield(get_tree(),"idle_frame")
	
	path = find_mst(room_positions)
	
	make_map()

func _process(delta):
	update()


func _input(event):
	if event.is_action_pressed('ui_select'):
		for n in $Rooms.get_children():
			n.queue_free()
		make_rooms()
	if event.is_action_pressed('ui_cancel'):
		#erase rigidbodies
		for room in $Rooms.get_children():
			room.queue_free()
		
		player = Player.instance()
		add_child(player)
		player.position = start_room.position
		play_mode = true


func find_mst(nodes):
	# Prim's algorithm
	# Given an array of positions (nodes), generates a minimum
	# spanning tree
	# Returns an AStar object

	# Initialize the AStar and add the first point
	var path = AStar.new()
	path.add_point(path.get_available_point_id(), nodes.pop_front())

	# Repeat until no more nodes remain
	while nodes:
		var min_dist = INF  # Minimum distance found so far
		var min_p = null  # Position of that node
		var p = null  # Current position
		# Loop through the points in the path
		for p1 in path.get_points():
			p1 = path.get_point_position(p1)
			# Loop through the remaining nodes in the given array
			for p2 in nodes:
				# If the node is closer, make it the closest
				if p1.distance_to(p2) < min_dist:
					min_dist = p1.distance_to(p2)
					min_p = p2
					p = p1
		# Insert the resulting node into the path and add
		# its connection
		var n = path.get_available_point_id()
		path.add_point(n, min_p)
		path.connect_points(path.get_closest_point(p), n)
		# Remove the node from the array so it isn't visited again
		nodes.erase(min_p)
	return path
	#notstolen#100%original
	# credit goes to kidscancode

func make_map():
	find_start_room()
	find_end_room()
	
	Map.clear()
	
	var full_rect = Rect2()
	for room in $Rooms.get_children():
		var r = Rect2(room.position-room.size, room.get_node("CollisionShape2D").shape.extents*2)
		full_rect = full_rect.merge(r)
	var topleft = Map.world_to_map(full_rect.position)
	var bottomright = Map.world_to_map(full_rect.end)
	for x in range(topleft.x, bottomright.x):
		for y in range(topleft.y,bottomright.y):
			Map.set_cell(x,y,2)
	
	var corridors = []
	for room in $Rooms.get_children():
		var s = (room.size/tile_size).floor()
		var pos = Map.world_to_map(room.position)
		var ul = (room.position/tile_size).floor()-s
		for x in range(2,s.x*2-1):
			for y in range(2, s.y*2-1):
				Map.set_cell(ul.x+x, ul.y+y, 1)
	
		var p = path.get_closest_point(Vector3(room.position.x, room.position.y,0))
		for conn in path.get_point_connections(p):
			if not conn in corridors:
				var start = Map.world_to_map(Vector2(path.get_point_position(p).x, path.get_point_position(p).y))
				var end = Map.world_to_map(Vector2(path.get_point_position(conn).x, path.get_point_position(conn).y))
				carve_path(start, end)
		corridors.append(p)


func carve_path(pos1, pos2):
	# Carves a path between two points
	var x_diff = sign(pos2.x - pos1.x)
	var y_diff = sign(pos2.y - pos1.y)
	if x_diff == 0: x_diff = pow(-1.0, randi() % 2)
	if y_diff == 0: y_diff = pow(-1.0, randi() % 2)
	# Carve either x/y or y/x
	var x_y = pos1
	var y_x = pos2
	if (randi() % 2) > 0:
		x_y = pos2
		y_x = pos1
	for x in range(pos1.x, pos2.x, x_diff):
		Map.set_cell(x, x_y.y, 1)
		Map.set_cell(x, x_y.y+y_diff, 1)  # widen the corridor
	for y in range(pos1.y, pos2.y, y_diff):
		Map.set_cell(y_x.x, y, 1)
		Map.set_cell(y_x.x+x_diff, y, 1)  # widen the corridor
	


func find_start_room():
	var min_x = INF
	for room in $Rooms.get_children():
		if room.position.x < min_x:
			start_room = room
			min_x = room.position.x

func find_end_room():
	var max_x = -INF
	for room in $Rooms.get_children():
		if room.position.x > max_x:
			end_room = room
			max_x = room.position.x






