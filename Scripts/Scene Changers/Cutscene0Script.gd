extends AnimatedSprite2D

func _on_animation_finished():
	get_tree().change_scene_to_file("res://Scenes/Levels/Level0.tscn")
