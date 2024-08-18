extends Node


var level_scenes = [
	"res://ui/main_menu/main_menu.tscn",
	"res://levels/marian.tscn", 
	"res://levels/brutus.tscn",
]

var current_level_id = 0

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("esc"):
		Globals.load_main_menu()

func play_i(i, is_start):
	for pa in get_tree().get_nodes_in_group("grandpa"):
		pa.play_i(i, is_start)

func set_sfx_volume(value: int) -> void:
	print("Setting sfx volume to " + str(value))
	
func set_music_volume(value: int) -> void:
	print("Setting music volume to " + str(value))

func reload_level() -> void:
	get_tree().reload_current_scene()
	
func load_next_level():
	current_level_id += 1
	if current_level_id >= level_scenes.size():
		load_main_menu()
	get_tree().change_scene_to_file(level_scenes[current_level_id])

func load_main_menu():
	current_level_id = 0
	get_tree().change_scene_to_file("res://ui/main_menu/main_menu.tscn")
	
func load_options():
	get_tree().change_scene_to_file("res://ui/Options/options.tscn")
	
func load_credits():
	get_tree().change_scene_to_file("res://ui/Credits/credits.tscn")
