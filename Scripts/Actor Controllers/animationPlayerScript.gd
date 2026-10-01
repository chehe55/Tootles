extends AnimationPlayer

func _on_deleter_move_trigger_area_entered(area: Area2D) -> void:
	play("moveLeft")
