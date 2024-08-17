extends Control


func _on_start_game_button_down() -> void:
	Globals.load_next_level()


func _on_options_button_down() -> void:
	Globals.load_options()


func _on_credits_button_down() -> void:
	Globals.load_credits()


func _on_exit_button_down() -> void:
	get_tree().quit()
