extends CharacterBody2D

@onready var shield_indicator: ShieldIndicator = $"../CanvasLayer/ShieldIndicator"

const speed = 150
var health = 3
var takenDamage = false
var stunned = false
var shieldMode = false
var shieldReady = true
@onready var heart1: Sprite2D = $"../CanvasLayer/Hearts1"
@onready var heart2: Sprite2D = $"../CanvasLayer/Hearts2"
@onready var heart3: Sprite2D = $"../CanvasLayer/Hearts3"
@onready var waterCutsceneVideo: VideoStreamPlayer = $"../WaterCutsceneVideo"
@onready var takeOneHeartSound: AudioStreamPlayer2D = $"../takeOneHeartSound"
@onready var shieldOnSound: AudioStreamPlayer2D = $"../shieldOnSound"

func _physics_process(delta):
	player_movement(delta)
	showHealth()
	if Input.is_action_just_pressed("shield") && shieldReady && !takenDamage:
		shieldMode = true
		shieldReady = false
		$shieldTimer.start()
		$coolDownTimer.start()
		shield_indicator.startShortCDAnim()
		shieldOnSound.play()

func player_movement(delta):
	if (!stunned):
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
		if !stunned:
			velocity.x = speed * cos(rotation)
			velocity.y = speed * sin(rotation)
			if(shieldMode):
				play_anim(5)
			elif(takenDamage):
				play_anim(3)
			else:
				play_anim(1)
		else:
			velocity.x = 0
			velocity.y = 0
			if(takenDamage):
				play_anim(2)
			else:
				play_anim(0)
	
	else:
		if(takenDamage):
			play_anim(2)
			velocity.x = 0
			velocity.y = 0
		elif(shieldMode):
			play_anim(4)
			velocity.x = 0
			velocity.y = 0
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
	elif movement == 2:
		$AnimatedSprite2D.play("idle_damage")
	elif movement == 3:
		$AnimatedSprite2D.play("moving_damage")
	elif movement == 4:
		$AnimatedSprite2D.play("idle_shield")
	elif movement == 5:
		$AnimatedSprite2D.play("moving_shield")

func _on_area_2d_area_entered(area):
	if !takenDamage:
		takeDamage()

func takeDamage():
	if(!shieldMode):
		health = health - 1
		$damageTimer.start()
		takenDamage = true
		takeOneHeartSound.play()
		$stunTimer.start()
		stunned = true
		#If health is 0, transitions to death scene
		if health == 0:
			get_tree().call_deferred("change_scene_to_file", "res://Scenes/Menus/GameOver2.tscn")

func getHealth():
	return health

func showHealth():
	if health == 3:
		heart3.show()
		heart2.hide()
		heart1.hide()
	elif health == 2:
		heart3.hide()
		heart2.show()
		heart1.hide()
	elif health == 1:
		heart3.hide()
		heart2.hide()
		heart1.show()

func _on_damage_timer_timeout() :
	takenDamage = false
	$damageTimer.stop()


func _on_shield_timer_timeout():
	shieldMode = false
	$shieldTimer.stop()


func _on_cool_down_timer_timeout():
	shieldReady = true
	$coolDownTimer.stop()


func _on_stun_timer_timeout():
	stunned = false
	$stunTimer.stop()
