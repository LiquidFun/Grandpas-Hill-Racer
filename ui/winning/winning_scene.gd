extends CanvasLayer



func _on_next_level_button_down() -> void:
	Globals.load_next_level()


func _on_replay_button_down() -> void:
	Globals.reload_level()


func _on_main_menu_button_down() -> void:
	Globals.load_main_menu()
