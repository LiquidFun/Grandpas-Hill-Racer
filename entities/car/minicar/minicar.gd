extends RigidBody2D

@export var frozen = true

func set_freeze(status):
	freeze = status
	$WheelJoint/Wheel.freeze = status
	$WheelJoint2/Wheel.freeze = status
	
func _ready():
	set_freeze(frozen)

func _unhandled_input(_event):
	if Input.is_action_just_pressed("minicar"):
		set_freeze(false)
		var camera = get_tree().get_first_node_in_group("camera")
		camera.enabled = false
		#if camera != null:
		#	camera.reparent(self)
		self.reparent(get_tree().get_current_scene())
		$Camera2D.enabled = true
		
