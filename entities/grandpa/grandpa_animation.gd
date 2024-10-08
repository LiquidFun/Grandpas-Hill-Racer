extends AnimatedSprite2D

@export_enum("Idle", "Jump") var anim: String = "Idle"
@export var flip: bool = false
@export var is_start: bool = true
@onready var label = $Node2D/Label

var first_entered = true
var stop_now = false
var dialogue = [
	"I left behind some scrap.\nPlease build a machine and come visit me.\nI miss you dearly!\nPress enter to start driving.",
	"Off you go!",
	"You did it!\nYatta!\nI can't believe it!\nHere, a coin as thanks :)",
]

func _ready() -> void:
	self.play(anim)
	if anim == "Jump":
		self.position.y += scale.y * 3
	print(anim)
	flip_h = flip
	if flip:
		$Node2D.position.x += 10

func play_i(i, start):
	if is_start == start:
		play_text(dialogue[i])

func play_text(text: String):
	if label == null:
		await get_tree().create_timer(1).timeout
	if text == dialogue[1]:
		stop_now = true
	if text == dialogue[2]:
		play("Jump")
		self.position.y += scale.y * 3
	label.text = ""
	for c in text:
		if stop_now and text == dialogue[0]:
			break
		label.text += c
		await get_tree().create_timer(0.02).timeout


func _on_area_2d_body_entered(body: Node2D) -> void:
	if (body.is_in_group("player") or body.is_in_group("part")) and not is_start:
		if first_entered:
			play_text(dialogue[2])
			first_entered = false
