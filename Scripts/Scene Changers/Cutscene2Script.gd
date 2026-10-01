extends AnimatedSprite2D

func _on_animation_finished() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/Level2.tscn")
