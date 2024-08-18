extends RigidBody2D

var power = 3_000_000

func _physics_process(delta):
	if Input.is_action_pressed("forward"):
		apply_torque(power)
	elif Input.is_action_pressed("backward"):
		apply_torque(-power)
