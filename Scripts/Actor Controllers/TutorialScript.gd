extends Area2D

var moving = false

func _process(delta):
	if moving:
		position.x += 500 * delta

func startMoving():
	moving = true
