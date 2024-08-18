extends Control

enum {AD, WS}

@onready var buttons = [
	$Panel/MarginContainer/VBoxContainer2/VBoxContainer/HBoxContainer/AD,
	$Panel/MarginContainer/VBoxContainer2/VBoxContainer/HBoxContainer/WS,
]


func _on_exit_button_down() -> void:
	Globals.load_main_menu()
	

func _on_sfx_value_changed(value: float) -> void:
	Globals.set_sfx_volume(value)


func _on_music_value_changed(value: float) -> void:
	Globals.set_music_volume(value)



func _on_ad_toggled(toggled_on: bool) -> void:
	buttons[WS].set_pressed_no_signal(false)


func _on_ws_toggled(toggled_on: bool) -> void:
	buttons[AD].set_pressed_no_signal(false)
