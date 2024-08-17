extends Node2D

const PART_SCENES = [
	preload("res://entities/car/cube/cube.tscn"),
	preload("res://entities/car/plank/plank.tscn"),
	preload("res://entities/car/tire/tire.tscn"),
]

const CAR_SCENE = preload("res://entities/car/rigid/car.tscn")
const WHEEL_SCENE = preload("res://entities/car/rigid/wheel.tscn")
const WHEEL_AXIS_SCENE = preload("res://entities/car/rigid/wheel_spring.tscn")
		
const ROTATE_BY = deg_to_rad(45/4.0)

var selected_part: Area2D = null
var first_part_was_placed = false
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
	camera.position = camera_pos
	camera.position_smoothing_enabled = true
	camera.position = Vector2.ZERO
	car.position = placed_parts[0].position
	#hull.add_child(car)
	for part in placed_parts:
		get_parent().remove_child(part)
		#part.get_node("Placement").queue_free()
		var sprite = part.get_node("Sprite2D")
		part.remove_child(sprite)
		part.get_node("Collision").disabled = false
		
		var collision = part.get_node("Collision")
		part.remove_child(collision)
		
		if part.is_in_group("tire"):
			var wheel = WHEEL_SCENE.instantiate()
			wheel.add_child(sprite)
			wheel.add_child(collision)
			sprite.position = Vector2.ZERO
			collision.position = Vector2.ZERO
			
			var wheel_axis = WHEEL_AXIS_SCENE.instantiate()
			
			wheel_axis.add_child(wheel)
			wheel.position = Vector2.ZERO
			car.add_child(wheel_axis)
			wheel_axis.global_position = part.global_position
			
			wheel_axis.node_a = car.get_path()
			wheel_axis.node_b = wheel.get_path()
		else:
			car.add_child(sprite)
			car.add_child(collision)
			sprite.global_position = part.global_position
			collision.global_position = part.global_position
			collision.rotation = part.rotation
			sprite.rotation = part.rotation
			# part.position = Vector2.ZERO
			# collision.position = Vector2.ZERO
		

func _unhandled_input(event):
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
		
	if Input.is_action_pressed("start"):
		_start()
		
	#if Input.is_action_pressed("pan"):
	#	if event is InputEventMouseMotion:
	#		camera.position -= event.screen_relative
	
	if !started and selected_part != null:
		if event is InputEventMouseMotion:
			selected_part.global_position = get_global_mouse_position()
			_set_selected_part_color()
			
		if Input.is_action_just_pressed("place") and _can_selected_part_can_be_placed():
			selected_part.modulate = Color(1, 1, 1, 1)
			placed_parts.append(selected_part)
			selected_part = null
			first_part_was_placed = true
			
		if Input.is_action_just_pressed("cancel"):
			get_parent().remove_child(selected_part)
			selected_part = null
			
		if Input.is_action_just_pressed("rotate_left"):
			selected_part.rotate(ROTATE_BY)
			
		if Input.is_action_just_pressed("rotate_right"):
			selected_part.rotate(-ROTATE_BY)
			
			
func _can_selected_part_can_be_placed() -> bool:
	for area in selected_part.get_overlapping_areas():
		if area.is_in_group("car"):
			return true
	return !first_part_was_placed
	
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
