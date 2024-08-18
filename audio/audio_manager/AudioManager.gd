extends Node

const background_music: Array = [
	# input list of background music files goes here
	# background music is randomly shuffled
	# preload("<path_to_file>")
	]
	
# define an object like sound_example for each individual sound you want to play
const sound_example: Array = [
	# provide a single or a list of sound files
	# # preload("<path_to_file>")
]

const button_click: Array = [
	
]

const button_hover: Array = [
	
]

var music_volume: float = 3
var sound_volume: float = 3

@onready var background_player = $BackgroundMusic


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_on_background_music_finished()
	set_music_volume(music_volume)

# SOUNDS

# to play a sound call AudioManager.play_sound_example()
func play_sound_example() -> void:
	if sound_example.is_empty():
		push_warning("This function should not be called since it is only an example function")
		return
	_create_sound_player(sound_example.pick_random(), null, false, 0.5)


func play_button_hover() -> void:
	if button_hover.is_empty():
		push_warning("No button hover sound defined yet. Please fill the Array button_hover with tracks to play")
		return
	_create_sound_player(button_hover.pick_random(), null, false, 0.5)


func play_button_click() -> void:
	if button_click.is_empty():
		push_warning("No button click sound defined yet. Please fill the Array button_click with sounds to play")
		return
	_create_sound_player(button_click.pick_random(), null, false, 0.5)


# HELPER
func set_sound_volume(percent:float) -> void:
	sound_volume = percent
	
	
func set_music_volume(percent:float) -> void:
	music_volume = percent
	background_player.volume_db = linear_to_db((float(music_volume)/100.0))

# creates a player with 
# sound: the array defined in this script with the given sound name
# position: if null the sound is played without a world-location
# modify: alters the pitch of the given sound to sound less repetetive
# volume_factor: use to balance sound volume vs master volume
func _create_sound_player(sound, position, modify = true, volume_factor: float =1) -> void:
	var player
	if position == null:
		player = AudioStreamPlayer.new()
	else:
		player = AudioStreamPlayer2D.new()
	get_tree().root.add_child(player)
	if position:
		player.global_position = position
	player.stream = sound
	player.volume_db = linear_to_db((float(sound_volume*volume_factor)/100.0)*2)
	player.play()
	if modify:
		player.pitch_scale = 1 + randf_range(-0.2, +0.2)
	player.finished.connect(_on_sound_finished.bind(player))


func _on_background_music_finished() -> void:
	if background_music.is_empty():
		push_warning("No Background Music defined yet. Please fill the Array background_music with tracks to play")
		return
	background_player.stream = background_music.pick_random()
	background_player.play()


func _on_sound_finished(player) -> void:
	player.queue_free()
