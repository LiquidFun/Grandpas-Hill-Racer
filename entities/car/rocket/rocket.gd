extends Node2D

var angle = null
enum {OFF, ON}

@onready var sprite: AnimatedSprite2D = $Sprite2D2

func _unhandled_input(_event):
	if Input.is_action_just_pressed("rocket"):
		angle = global_rotation + PI/2
		sprite.frame = ON
	if Input.is_action_just_released("rocket"):
		sprite.frame = OFF
		
		

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
				car.apply_torque(-10_000_000 * correction * delta)
