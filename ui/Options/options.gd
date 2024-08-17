extends Control


func _on_exit_button_down() -> void:
	Globals.load_main_menu()
	

func _on_sfx_value_changed(value: float) -> void:
	Globals.set_sfx_volume(value)


func _on_music_value_changed(value: float) -> void:
	Globals.set_music_volume(value)
