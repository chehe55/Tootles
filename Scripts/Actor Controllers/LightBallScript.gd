extends Node2D

func _process(delta):
	position.x += 500 * delta

func _on_hitbox_area_entered(area: Area2D) -> void:
	queue_free()
