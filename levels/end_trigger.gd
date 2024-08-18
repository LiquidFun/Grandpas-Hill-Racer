extends Area2D

var winning_scene = preload("res://ui/winning/winning scene.tscn")

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") or body.is_in_group("car"):
		Globals.play_i(2, false)
		
		Audio.play("game_won")
		
		print("WON GAME!")
		var scene = winning_scene.instantiate()
		get_parent().add_child(scene)
		queue_free()
