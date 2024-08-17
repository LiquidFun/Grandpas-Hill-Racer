extends RigidBody2D



func _process(delta):
	if has_node("Camera2D"):
		var camera = get_node("Camera2D")
		var target = Vector2(0, -100) + self.linear_velocity / 2
		var size = get_viewport_rect().size
		var border = 200
		target.x = clamp(target.x, border - size.x/2, size.x/2 - border)
		target.y = clamp(target.y, border - size.y/2, size.y/2 - border)
		camera.offset = camera.offset.lerp(target, delta * 2)   # *1 Vector2(1, 2)
