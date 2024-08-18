extends Control

enum {BOX, PLANK, WHEEL, ROCKET, SPRING, MINICAR}

@onready var buttons = [
	$MarginContainer/CenterContainer/HBoxContainer/Box,
	$MarginContainer/CenterContainer/HBoxContainer/Plank,
	$MarginContainer/CenterContainer/HBoxContainer/Wheel,
	$MarginContainer/CenterContainer/HBoxContainer/Rocket,
	$MarginContainer/CenterContainer/HBoxContainer/Spring,
	$MarginContainer/CenterContainer/HBoxContainer/Minicar,
]

@onready var quantitylabels = [
	$MarginContainer/CenterContainer/HBoxContainer/Box/Label2,
	$MarginContainer/CenterContainer/HBoxContainer/Plank/Label2,
	$MarginContainer/CenterContainer/HBoxContainer/Wheel/Label2,
	$MarginContainer/CenterContainer/HBoxContainer/Rocket/Label2,
	$MarginContainer/CenterContainer/HBoxContainer/Spring/Label2,
	$MarginContainer/CenterContainer/HBoxContainer/Minicar/Label2,
]

var g_controller
var first = true

func update_quantities(quantities, start_quantities):
	for i in range(len(quantitylabels)):
		quantitylabels[i].text = str(quantities[i]) + "/" + str(start_quantities[i])
		if start_quantities[i] == 0:
			buttons[i].visible = false

func _ready():
	g_controller = get_tree().get_first_node_in_group("game_controller")
	update_quantities.call_deferred(g_controller.quantities, g_controller.start_quantities)

func press(ind: int):
	buttons[ind].set_pressed_no_signal(true)
	disable_others(ind)

func disable_others(ind: int):
	for i in range(len(buttons)):
		if i != ind:
			buttons[i].set_pressed_no_signal(false)

func _on_box_toggled(_toggled_on: bool) -> void:
	disable_others(BOX)
	g_controller._select_part(BOX)
	
func _on_plank_toggled(_toggled_on: bool) -> void:
	disable_others(PLANK)
	g_controller._select_part(PLANK)

func _on_wheel_toggled(_toggled_on: bool) -> void:
	disable_others(WHEEL)
	g_controller._select_part(WHEEL)

func _on_rocket_toggled(_toggled_on: bool) -> void:
	disable_others(ROCKET)
	g_controller._select_part(ROCKET)

func _on_spring_toggled(_toggled_on: bool) -> void:
	disable_others(SPRING)
	g_controller._select_part(SPRING)

func _on_minicar_toggled(_toggled_on: bool) -> void:
	disable_others(MINICAR)
	g_controller._select_part(MINICAR)

func _on_play_button_down() -> void:
	g_controller._start()
