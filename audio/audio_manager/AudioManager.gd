extends Node

const background_music: Array = [
	# input list of background music files goes here
	# background music is randomly shuffled
	# preload("<path_to_file>")
	preload("res://audio/music/game-music-teste-204327.mp3")
	]
	
	
const sounds: Dictionary = {
	"place_wood": preload("res://audio/sfx/hit-by-a-wood-230542.mp3"),
	"place_metal": preload("res://audio/sfx/metal-beaten-sfx-230501.mp3"),
	"motor": preload("res://audio/sfx/v12-motor-engine-218824.mp3"),
	"game_won": preload("res://audio/sfx/sound-effect-for-games-131029.mp3"),
	"snap": preload("res://audio/sfx/snap-sound-effect-226112.mp3"),
	"woosh": preload("res://audio/sfx/rapid-wind-sound-effect-2-108400.mp3"),
	"pickup": preload("res://audio/sfx/pickupCoin.wav"),
	"echo": preload("res://audio/sfx/banished-sound-95250.mp3"),
	"wrong": preload("res://audio/sfx/wrong-47985.mp3"),
}

var music_volume: float = 30
var sound_volume: float = 10

@onready var background_player = AudioStreamPlayer.new()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(.1).timeout
	get_tree().root.add_child(background_player)
	set_music_volume(music_volume)
	background_player.finished.connect(_on_background_music_finished)
	_on_background_music_finished()

# SOUNDS

func play(name: String, volume_multiplier=1.0):
	_create_sound_player(sounds[name], null, false, volume_multiplier)
	

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
