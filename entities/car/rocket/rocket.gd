extends Node2D

var angle = null

func _unhandled_input(event):
	if Input.is_action_just_pressed("rocket"):
		angle = global_rotation + PI/2

func _physics_process(delta):
	if Input.is_action_pressed("rocket"):
		var car = get_parent().get_parent()
		if car is RigidBody2D:
			var rot = global_rotation- PI/2
			var vec = Vector2(cos(rot), sin(rot))
			car.apply_force(vec * 200_000, position)
			
			if angle != null:
				var correction = angle - global_rotation
				if correction > PI:
					correction = PI * 2 - correction
				car.apply_torque(-10_000_000 * correction)
