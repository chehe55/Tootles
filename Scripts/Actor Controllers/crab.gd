extends PathFollow2D

@export var speed = 0.15

func _ready():
	$AnimatedSprite2D.play("default")

func _process(delta):
	loop_movement(delta)

func loop_movement(delta):
	progress_ratio += delta * speed
