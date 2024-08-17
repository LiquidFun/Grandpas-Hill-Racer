extends AnimatedSprite2D

@export_enum("Idle", "Jump") var anim: String

func _ready() -> void:
	self.play(anim)
	print(anim)

func _process(delta: float) -> void:
	pass
