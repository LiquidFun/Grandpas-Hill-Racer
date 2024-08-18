extends Control

@onready var rocket = $MarginContainer/CenterContainer/HBoxContainer/Rocket
@onready var spring = $MarginContainer/CenterContainer/HBoxContainer/Spring
@onready var minicar = $MarginContainer/CenterContainer/HBoxContainer/Minicar

func enable_mini():
	minicar.visible=true
	
func enable_spring():
	spring.visible=true
	
func enable_rocket():
	rocket.visible=true


func throw_input_event(action: String, pressed: bool):
	var cancel_event = InputEventAction.new()
	cancel_event.action = action
	cancel_event.pressed = pressed
	Input.parse_input_event(cancel_event)

func _on_rocket_button_down() -> void:
	throw_input_event("rocket", true)

func _on_rocket_button_up() -> void:
	throw_input_event("rocket", false)

func _on_spring_button_down() -> void:
	throw_input_event("spring", true)

func _on_spring_button_up() -> void:
	throw_input_event("spring", false)

func _on_minicar_button_down() -> void:
	throw_input_event("minicar", true)

func _on_minicar_button_up() -> void:
	throw_input_event("minicar", false)
