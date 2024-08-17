extends Node


var level_scenes = [
	"res://levels/marian.tscn", 
	"res://levels/brutus.tscn",
]

var current_level_id = 0
	
func reload_level() -> void:
	get_tree().reload_current_scene()
	
func load_next_level():
	current_level_id += 1
	get_tree().change_scene_to_file(level_scenes[current_level_id])

func load_main_menu():
	get_tree().change_scene_to_file("res://ui/main_menu/main_menu.tscn")
