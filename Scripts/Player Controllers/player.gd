extends CharacterBody2D

const speed = 150

func _ready():
	rotation_degrees = 180

func _physics_process(delta):
	player_movement(delta)
	
func player_movement(delta):
	if Input.is_action_pressed("down") && Input.is_action_pressed("right"):
		rotation_degrees = 45
	elif Input.is_action_pressed("down") && Input.is_action_pressed("left"):
		rotation_degrees = 135
	elif Input.is_action_pressed("up") && Input.is_action_pressed("left"):
		rotation_degrees = -135
	elif Input.is_action_pressed("up") && Input.is_action_pressed("right"):
		rotation_degrees = -45
	elif Input.is_action_pressed("right"):
		rotation_degrees = 0
	elif Input.is_action_pressed("down"):
		rotation_degrees = 90
	elif Input.is_action_pressed("left"):
		rotation_degrees = 180
	elif Input.is_action_pressed("up"):
		rotation_degrees = -90
	
	if Input.is_action_pressed("right") or Input.is_action_pressed("left") or Input.is_action_pressed("down") or Input.is_action_pressed("up"):
		velocity.x = speed * cos(rotation)
		velocity.y = speed * sin(rotation)
		play_anim(1)
	
	else:
		play_anim(0)
		velocity.x = 0
		velocity.y = 0
	
	move_and_slide() 

func play_anim(movement):
	if movement == 0:
		$AnimatedSprite2D.play("idle")
	elif movement == 1:
		$AnimatedSprite2D.play("moving")

func _on_trigger_area_entered(area: Area2D) -> void:
	pass # Replace with function body.
