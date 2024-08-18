extends Node2D

@export var frozen = true

func set_freeze(status):
	$Minicar.freeze = status
	$Wheel.freeze = status
	$Wheel2.freeze = status
	
func _ready():
	set_freeze(frozen)

func _unhandled_input(_event):
	if Input.is_action_just_pressed("minicar") and get_tree().get_first_node_in_group("game_controller").started:
		set_freeze(false)
		var camera = get_tree().get_first_node_in_group("camera")
		camera.enabled = false
		#if camera != null:
		#	camera.reparent(self)
		self.reparent(get_tree().get_current_scene())
		$Minicar/Camera2D.enabled = true
		

func _physics_process(delta):
	if !$Minicar.freeze:
		var strength = Input.get_action_strength("left") - Input.get_action_strength("right")
		# print(strength)
		$Minicar.apply_torque(strength * 10_000_000 * delta)
