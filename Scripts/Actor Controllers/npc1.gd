extends PathFollow2D

var speed = 0.04

func _ready():
	$AnimatedSprite2D.play("default")

func _process(delta):
	loop_movement(delta)

func loop_movement(delta):
	progress_ratio += delta * speed
