extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_next_level_button_down() -> void:
	Globals.load_next_level()


func _on_replay_button_down() -> void:
	Globals.reload_level()


func _on_main_menu_button_down() -> void:
	Globals.load_main_menu()
