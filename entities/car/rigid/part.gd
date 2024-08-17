extends RigidBody2D

const POWER = 1_000_000

func _physics_process(delta):
	#if rotation_degrees < -1:
	#	apply_torque(POWER)
	#elif rotation_degrees > 1:
	apply_torque(-POWER * rotation_degrees)
