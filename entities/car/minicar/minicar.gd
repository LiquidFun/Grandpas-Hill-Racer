extends RigidBody2D

func _unhandled_input(event):
	if Input.is_action_just_pressed("minicar"):
		freeze = false
		$WheelJoint/Wheel.freeze = false
		$WheelJoint2/Wheel.freeze = false
