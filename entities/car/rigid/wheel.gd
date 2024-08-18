extends RigidBody2D

@export var power = 5_000_000 * 60

func _physics_process(delta):
	var strength = Input.get_action_strength("forward") - Input.get_action_strength("backward")
	apply_torque(strength * power * delta)
	#var limit = 3000
	#print(angular_velocity)
	#angular_velocity = clamp(angular_velocity, -limit, limit)
	
	#print(angular_velocity)
