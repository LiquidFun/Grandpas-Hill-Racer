extends Node2D

const PART_SCENES = [
	preload("res://entities/car/cube/cube.tscn"),
	preload("res://entities/car/plank/plank.tscn"),
	preload("res://entities/car/tire/tire.tscn"),
]

const CAR_SCENE = preload("res://entities/car/rigid/car.tscn")
const WHEEL_SCENE = preload("res://entities/car/rigid/wheel.tscn")
const WHEEL_JOINT_SCENE = preload("res://entities/car/rigid/wheel_joint.tscn")
const PART_JOINT_SCENE = preload("res://entities/car/rigid/part_joint.tscn")
const PART_SCENE = preload("res://entities/car/rigid/part.tscn")


		
const ROTATE_BY = deg_to_rad(45/4.0)

var selected_part: Area2D = null
var placed_parts = []
@export var started = false

@onready var camera = $Camera2D
 
func _start():
	if started or len(placed_parts) == 0:
		return
	started = true
	
	if selected_part != null:
		get_parent().remove_child(selected_part)
		
	remove_child(camera)
	var camera_pos = camera.global_position
	
	var car = CAR_SCENE.instantiate()
	car.add_child(camera)
	add_sibling(car)
	camera.global_position = camera_pos
	camera.position_smoothing_enabled = true
	camera.position = Vector2.ZERO
	car.position = placed_parts[0].position
	
	var now_placed = []
	var index = 0
	#hull.add_child(car)
	for placed in placed_parts:
		get_parent().remove_child(placed)
		#part.get_node("Placement").queue_free()
		var sprite = placed.get_node("Sprite2D")
		placed.remove_child(sprite)
		placed.get_node("Collision").disabled = false
		
		var collision = placed.get_node("Collision")
		placed.remove_child(collision)
		
		collision.global_rotation = placed.global_rotation
		sprite.global_rotation = placed.global_rotation
		
		if index == 0:
			car.add_child(sprite)
			car.add_child(collision)
			sprite.global_position = placed.global_position
			collision.global_position = placed.global_position
			now_placed.append(car)

		else:
			var is_tire = placed.is_in_group("tire") 
			var part = (WHEEL_SCENE if is_tire else PART_SCENE).instantiate()
			part.add_child(sprite)
			part.add_child(collision)
			sprite.position = Vector2.ZERO
			collision.position = Vector2.ZERO
			
			var joint = (WHEEL_JOINT_SCENE if is_tire else PART_JOINT_SCENE).instantiate()
			
			
			# part.get_colliding_bodies()
			
			car.add_child(joint)
			joint.add_child(part)
			
			part.global_position = placed.global_position
			
			#await get_tree().physics_frame
			#await get_tree().physics_frame
			#await get_tree().physics_frame
			#2continue
			joint.node_a = car.get_path()
			
			for previous_part in now_placed:
				var vec = _find_intersection_point(previous_part, part)
				if vec != Vector2.INF:
					joint.global_position = vec
		
					joint.node_a = previous_part.get_path()
					
					break
			if is_tire:
				joint.global_position = placed.global_position
			else:
				now_placed.append(part)

			part.global_position = placed.global_position

			joint.node_b = part.get_path()
		index += 1
		
func getArray(shape: Shape2D, pos: Vector2, transf: Transform2D) -> PackedVector2Array:
	var vertices: PackedVector2Array = PackedVector2Array()
	if shape is CircleShape2D:
		var circle_radius = shape.radius
		var num_segments = 40
		for i in range(num_segments):
			var angle = i * (2 * PI / num_segments)
			var x = circle_radius * cos(angle)
			var y = circle_radius * sin(angle)
			vertices.append(Vector2(x, y))
	elif shape is RectangleShape2D:
		var sz = shape.size
		for x in [-.5,.5]:
			for y in [-.5,.5]:
				vertices.append(Vector2(sz.x*x, sz.y*y))
	else:
		assert(false)
	
	var vertices2: PackedVector2Array = PackedVector2Array()
	for vertex in vertices:
		vertices2.append(transf * vertex)
	return vertices2
			
func _find_intersection_point(body1: CollisionObject2D, body2: CollisionObject2D) -> Vector2:
	var shape1 = body1.get_node("Collision").shape
	var shape2 = body2.get_node("Collision").shape
	
	"""var a1 = getArray(shape1, body1.get_node("Collision").global_position, body1.get_node("Collision").global_transform)
	var a2= getArray(shape2, body2.get_node("Collision").global_position, body2.get_node("Collision").global_transform)
	
	var diff = Geometry2D.intersect_polygons(a1, a2)
	
	if diff.size() == 0:
		return Vector2.INF

	var sum = Vector2.ZERO
	var count = 0
	for x in diff[0]:
		sum += x
		count += 1
			
	var mid = sum / count
	
		
	for i in range(len(a1)):
		a1[i] += (a1[i] - mid) * 0.01
	for i in range(len(a2)):
		a2[i] += (a2[i] - mid) * 0.01
	
	assert(Geometry2D.is_point_in_polygon(mid, a1))
	assert(Geometry2D.is_point_in_polygon(mid, a2))"""
	
	var a = shape1.collide_and_get_contacts(body1.get_node("Collision").global_transform, shape2, body2.get_node("Collision").global_transform)
	
	# assert(Geometry2D.is_point_in_polygon(a[0], a1))
	# assert(Geometry2D.is_point_in_polygon(a[0], a2))
	
	if a:
		return a[0]
	return Vector2.INF

func _find_intersection_point_wrong(body1: CollisionObject2D, body2: CollisionObject2D) -> Vector2:
	var start_point = body1.global_position
	var end_point = body2.global_position
	print_debug(start_point, end_point)
	
	while start_point.distance_to(end_point) > 0.1: 
		var mid_point = (start_point + end_point) / 2
		var in_body1 = _point_in_body(mid_point, body1)
		var in_body2 = _point_in_body(mid_point, body2)
		print(mid_point)
		if in_body1 and in_body2:
			print(true)
			return mid_point
		if in_body1:
			start_point = mid_point
		else:
			end_point = mid_point
	
	return Vector2.INF
	
func _point_in_body(point: Vector2, body: RigidBody2D): 
	var pointParameters := PhysicsPointQueryParameters2D.new()  
	pointParameters.collide_with_areas = true  
	pointParameters.collide_with_bodies = true
	pointParameters.position = point  
	
	var space := get_world_2d().direct_space_state  
	for collision_dict in space.intersect_point(pointParameters):
		print(collision_dict, body)
		if body == collision_dict["collider"]:
			return true
	return false

func _unhandled_input(event):
	if Input.is_action_pressed("start"):
		_start()
<<<<<<< HEAD
		
	if Input.is_action_pressed("restart"):
		get_tree().reload_current_scene()
			
=======

>>>>>>> 393aba3af285583f75a1a782d59e40e6ec9dda30
	if not started:
		if Input.is_action_just_pressed("item1"):
			_select_part(0)
		if Input.is_action_just_pressed("item2"):
			_select_part(1)
		if Input.is_action_just_pressed("item3"):
			_select_part(2)
		if Input.is_action_just_pressed("item4"):
			_select_part(3)
		if Input.is_action_just_pressed("item5"):
			_select_part(4)
		
		if Input.is_action_pressed("pan"):
			if event is InputEventMouseMotion:
				camera.position -= event.screen_relative
				
		if placed_parts:
			if Input.is_action_just_pressed("undo"):
				var part = placed_parts.pop_back()
				get_parent().remove_child(part)
	
		if selected_part != null:
			if event is InputEventMouseMotion:
				selected_part.global_position = get_global_mouse_position()
				_set_selected_part_color()
				
			if Input.is_action_just_pressed("place") and _can_selected_part_can_be_placed():
				selected_part.modulate = Color(1, 1, 1, 1)
				placed_parts.append(selected_part)
				selected_part = null
				
			if Input.is_action_just_pressed("cancel"):
				get_parent().remove_child(selected_part)
				selected_part = null
				
			if Input.is_action_just_pressed("rotate_left"):
				selected_part.rotate(ROTATE_BY)
				_set_selected_part_color()

				
			if Input.is_action_just_pressed("rotate_right"):
				selected_part.rotate(-ROTATE_BY)
				_set_selected_part_color()
			
			
func _can_selected_part_can_be_placed() -> bool:
	for area in selected_part.get_overlapping_areas():
		if area.is_in_group("car"):
			return true
	return len(placed_parts) == 0
	
func _select_part(index: int):
	if index >= len(PART_SCENES):
		return
		
	if selected_part != null:
		get_parent().remove_child(selected_part)
		
	selected_part = PART_SCENES[index].instantiate()
	add_sibling(selected_part)
	selected_part.global_position = get_global_mouse_position()
	
	# Await 2 physics frames until updating selected part color, because otherwise
	# the overlapping areas call does not return anything
	await get_tree().physics_frame
	await get_tree().physics_frame

	_set_selected_part_color()

func _set_selected_part_color():
	if _can_selected_part_can_be_placed():
		selected_part.modulate = Color(0.5, 1, 0, 0.75)
	else:
		selected_part.modulate = Color(1, 0.5, 0.5, 0.75)
