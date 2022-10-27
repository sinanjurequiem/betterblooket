extends Node2D

var Room = preload("res://room.tscn")

var tile_size = 32  # size of a tile in the TileMap
var num_rooms = 50  # number of rooms to generate
var min_size = 4  # minimum room size (in tiles)
var max_size = 10  # maximum room size (in tiles)

var hspread = 400 #horizontal spread
var vspread = 400 #vertical spread

var cull = 0.5 # chance to oof room

var path # path data

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
	
	yield(get_tree().create_timer(0.75),"timeout")
	
	var room_positions = []
	for room in $Rooms.get_children():
		if randf()<cull:
			room.queue_free()
		else:
			room.mode = RigidBody2D.MODE_STATIC
			room_positions.append(Vector3(room.position.x,room.position.y,0))
	
	yield(get_tree(),"idle_frame")
	
	path = find_mst(room_positions)

func _draw():
	for room in $Rooms.get_children():
		draw_rect(Rect2(room.position - room.size, room.size*2), Color(32, 228, 0), false)
	
	if path:
		for p in path.get_points():
			for c in path.get_point_connections(p):
				var pp = path.get_point_position(p) #comedic
				var cp = path.get_point_position(c) #not so comedic
				draw_line(Vector2(pp.x,pp.y), Vector2(cp.x,cp.y), Color(1,1,0,1),15,true)

func _process(delta):
	update()


func _input(event):
	if event.is_action_pressed('ui_select'):
		for n in $Rooms.get_children():
			n.queue_free()
		make_rooms()

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
