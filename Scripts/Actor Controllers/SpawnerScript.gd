extends Node2D

func spawnBall():
	var newBall = load("res://Scenes/Actors/Ball Stuff/LightBall.tscn")
	var instance = newBall.instantiate()
	instance.set_position(position)
	get_parent().add_sibling(instance)
