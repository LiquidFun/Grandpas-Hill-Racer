extends Node2D

@onready var initial_scale = scale
@onready var initial_position = null
var retracted = true


func spring():
	var tween = create_tween()
	
	if initial_position == null:
		initial_position = position
	
	var rot = rotation + PI / 2
	var vec = Vector2(cos(rot), sin(rot))
	var car = get_parent().get_parent().get_parent()
	if car is RigidBody2D:
		car.apply_impulse(-vec * 200_000, position)
	
	tween.tween_property(self, "scale", Vector2(initial_scale.x, 3), 0.3) \
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween.parallel().tween_property(self, "position", initial_position + Vector2.ONE * 60 * vec, 0.3) \
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
		
	tween.tween_property(self, "scale", initial_scale, 1) \
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.parallel().tween_property(self, "position", initial_position, 1) \
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
		
	tween.tween_callback(func (): retracted = true)

func _unhandled_input(_event):
	if Input.is_action_just_pressed("spring"):
		if retracted:
			spring()
