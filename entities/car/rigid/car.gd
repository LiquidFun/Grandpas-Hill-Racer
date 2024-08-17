extends RigidBody2D

const POWER = 5_000_000

func _physics_process(delta):
	if Input.is_action_pressed("forward"):
		for wheel in get_tree().get_nodes_in_group("wheel"):
			wheel.apply_torque(POWER)
	elif Input.is_action_pressed("backward"):
		for wheel in get_tree().get_nodes_in_group("wheel"):
			wheel.apply_torque(-POWER)

func _process(delta):
	if has_node("Camera2D"):
		var camera = get_node("Camera2D")
		camera.offset = camera.offset.lerp(Vector2(0, -100) + self.linear_velocity / 2, delta * 2)   # *1 Vector2(1, 2)
