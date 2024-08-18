extends RigidBody2D

const POWER = 1_000_000 * 60

func _physics_process(_delta):
	var _rotation_degrees = fmod(rotation_degrees, 360)
	#apply_torque(-POWER * _rotation_degrees * _delta)
