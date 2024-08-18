extends PinJoint2D

var a
var b

const POWER = 500_000

var target_diff

func _ready():
	calibrate()

func calibrate():
	a = get_node(node_a)
	b = get_node(node_b)
	target_diff = a.rotation - b.rotation

func sigmoid(x) -> float:
	return 2 / (1 + exp(-x)) - 1

func _physics_process(delta):
	var angle = a.rotation - b.rotation
	var diff = target_diff - angle
	
	var torque = POWER * rad_to_deg(sigmoid(diff))
	print(diff, "\t", torque)
	a.apply_torque(torque)
