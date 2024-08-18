extends Area2D

var winning_scene = preload("res://ui/winning/winning scene.tscn")

func _on_body_entered(body: Node2D) -> void:
	print("found" + body.name)
	if body.is_in_group("player") or body.is_in_group("car") or body.is_in_group("part"):
		
		Audio.play("game_won")
		
		print("WON GAME!")
		var scene = winning_scene.instantiate()
		get_parent().add_child(scene)
		queue_free()


func _on_area_entered(area: Area2D) -> void:
	print("found" + area.name)
	if area.is_in_group("player") or area.is_in_group("car") or area.is_in_group("part"):
		
		Audio.play("game_won")
		
		print("WON GAME!")
		var scene = winning_scene.instantiate()
		get_parent().add_child(scene)
		queue_free()
