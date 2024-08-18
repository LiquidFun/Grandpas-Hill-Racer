extends RigidBody2D


var multiplier = 1

func _process(delta):
	if has_node("Camera2D"):
		var camera = get_node("Camera2D")
		var target = Vector2(0, -100) + self.linear_velocity / 2
		var size = get_viewport_rect().size
		var border = 200
		target.x = clamp(target.x, border - size.x/2, size.x/2 - border)
		target.y = clamp(target.y, border - size.y/2, size.y/2 - border)
		camera.offset = camera.offset.lerp(target, delta * 2)   # *1 Vector2(1, 2)


func calibrate():
	for child in get_parent().get_children():
		if child is RigidBody2D:
			multiplier += 1

func _physics_process(delta):
	var strength = Input.get_action_strength("left") - Input.get_action_strength("right")
	# print(strength)
	apply_torque(strength * 100_000_000 * delta * multiplier)
	
