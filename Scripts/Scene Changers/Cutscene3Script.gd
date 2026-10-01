extends AnimatedSprite2D

func _on_animation_finished() -> void:
	print("done")
	get_tree().change_scene_to_file("res://Scenes/Cutscenes/Credits.tscn")
