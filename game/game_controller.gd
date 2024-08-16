extends Node2D

const PART_SCENES = [
	preload("res://entities/car/cube/cube.tscn"),
	preload("res://entities/car/plank/plank.tscn"),
	preload("res://entities/car/wheel/wheel.tscn"),
]

const ROTATE_BY = deg_to_rad(45/4.0)

var selected_part: Area2D = null
var first_part_was_placed = false

func _ready():
	pass 

func _process(delta):
	pass

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
	
	if selected_part != null:
		if event is InputEventMouseMotion:
			selected_part.global_position = event.position
			_set_selected_part_color()
			
		if Input.is_action_just_pressed("place") and _can_selected_part_can_be_placed():
			selected_part.modulate = Color(1, 1, 1, 1)
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
	selected_part.position = get_viewport().get_mouse_position()
	_set_selected_part_color()

func _set_selected_part_color():
	if _can_selected_part_can_be_placed():
		selected_part.modulate = Color(0.5, 1, 0, 0.75)
	else:
		selected_part.modulate = Color(1, 0.5, 0.5, 0.75)
