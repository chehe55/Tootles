extends CharacterBody2D
class_name LanePlayer

@onready var shield_indicator: ShieldIndicator = $"../CanvasLayer/ShieldIndicator"
const speed = 75
const laneChangeFrames = 5

var latest_dir = "none"
var moveTimer = 0

var health = 3
#Whether or not the turtle is invincible(in shield mode) or not
var shieldMode = false
#whether the shieldmode can start
var shieldReady = true
var takenDamage = false
var paused = false
var doneTutorial = false
var heart3
var heart2
var heart1
var tutorialText = 1
@onready var tutorial1: Label = $"../CanvasLayer/Control/Tutorial1"
@onready var tutorial2: Label = $"../CanvasLayer/Control/Tutorial2"
@onready var tutorial3: Label = $"../CanvasLayer/Control/Tutorial3"
@onready var tutorial4: Label = $"../CanvasLayer/Control/Tutorial4"
@onready var takeOneHeartSound: AudioStreamPlayer2D = $"../takeOneHeartSound"
@onready var shieldOnSound: AudioStreamPlayer2D = $"../shieldOnSound"

func _ready():
	heart3 = $"../CanvasLayer/Hearts3"
	heart2 = $"../CanvasLayer/Hearts2"
	heart1 = $"../CanvasLayer/Hearts1"

func _physics_process(delta):
	#During tutorial
	if paused:
		tutorial()
		if Input.is_action_just_pressed("shield"):
			shieldMode = true
			shieldReady = false
			paused = false
			Engine.time_scale = 1
			print("UnPaused")
			#$"../CanvasLayer/Control/AnimationPlayer".play("text2")
			$shieldTimer.start()
			$coolDownTimer.start()
			shield_indicator.startShortCDAnim()	
			shieldOnSound.play()
	if !paused:
		player_movement(delta)
		#If the Space bar is pressed & not in cooldown mode & did not just take damage
		if Input.is_action_just_pressed("shield") && shieldReady && !takenDamage:
			shieldMode = true
			shieldReady = false
			$shieldTimer.start()
			$coolDownTimer.start()
			shield_indicator.startShortCDAnim()
			shieldOnSound.play()
			#print("Shield Activated")
	showHealth()
	
	#If the Space bar is pressed & not in cooldown mode
	if Input.is_action_just_pressed("shield") && shieldReady:
		shieldMode = true
		shieldReady = false
		$shieldTimer.start()
		$coolDownTimer.start()
		shield_indicator.startLongCDAnim()
		shieldOnSound.play()
		#print("Shield Activated")
		
	if Input.is_action_just_pressed("pause"):
		if(paused):
			Engine.time_scale = 1
			print("Not Paused")
		else:
			Engine.time_scale = 0
			print("Paused")
		paused = !paused

#cooldown is rn 5 seconds
func _on_cool_down_timer_timeout():
	shieldReady = true
	#print("Out of cooldown")
	$coolDownTimer.stop()

func _on_shield_timer_timeout():
	shieldMode = false
	#print("Shield Down") 
	$shieldTimer.stop()

func _on_damage_timer_timeout():
	takenDamage = false;
	$damageTimer.stop()

func player_movement(delta):
	
	if Input.is_action_just_pressed("down") && moveTimer <= 0:
		
		if position.y < 324:
			latest_dir = "down"
			moveTimer = laneChangeFrames
	
	elif Input.is_action_just_pressed("up") && moveTimer <= 0:
		
		if position.y > -216.0:
			latest_dir = "up"
			moveTimer = laneChangeFrames
	
	if latest_dir == "down" && moveTimer > 0:
		position.y = position.y + (135/laneChangeFrames)
	
	elif latest_dir == "up" && moveTimer > 0:
		position.y = position.y - (135/laneChangeFrames)
	
	if moveTimer > 0:
		moveTimer -= 1
	
	if !takenDamage: #only move if the player isn't taking damage --> move forward
		velocity.x = speed * 2
	else:
		velocity.x = 0
	if takenDamage:
		play_anim(2)
	elif shieldMode:
		play_anim(3)
	else:
		play_anim(1)
	move_and_slide()
	#print(position.y)

func play_anim(movement):
	var dir = latest_dir
	var anim = $AnimatedSprite2D
	if movement == 1:
		anim.play("forward")
	elif movement == 2:
		anim.flip_h
		anim.play("takeDamage")
	elif movement == 3:
		anim.play("shield")

func _on_hurtbox_area_entered(area: Area2D) -> void:
	if !shieldMode:
		takeDamage()
		print("taking damage")

func takeDamage():
	health = health - 1
	takenDamage = true
	$damageTimer.start()
	takeOneHeartSound.play()
	#print(health)
	#If health is 0, transitions to death scene
	if health == 0:
		get_tree().call_deferred("change_scene_to_file", "res://Scenes/Menus/GameOver1.tscn")
		

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

func tutorial():
	if Input.is_action_just_pressed("tutorialNext"):
		tutorialText = tutorialText + 1
	tutorial1.show()

#For when the turtle enters the area2d
#kinda scuffed since if the turtle takes damage earlier --> they are bounced back --> tutorial won't trigger
func _on_tutorial_trigger_area_entered(area: Area2D):
	if !doneTutorial: 
		#Engine.time_scale = 0
		#paused = true
		print("Paused from Tutorial")
		doneTutorial = true
