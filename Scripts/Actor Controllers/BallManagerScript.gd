extends Node2D

@onready var tutorial_trigger: Area2D = $"../TutorialTrigger"

var timer
var timerReset
var waveTimer
var tutorialLaunched
var tutorialTimer
var spawners

func _ready():
	timer = 5
	timerReset = 2
	waveTimer = 2
	tutorialLaunched = false
	tutorialTimer = 6.4
	spawners = get_children()

func _process(delta):
	
	timer -= delta
	
	if tutorialLaunched == false:
		tutorialTimer -= delta
	
	if tutorialTimer <= 0:
		tutorial_trigger.startMoving()
	
	if timer <= 0:
		
		if waveTimer == 0:
			spawnWave()
		
		else:
			spawnFew()
		
		timer = timerReset

func spawnFew():
	var selectedSpawners = []
	var spawnNum = randi_range(1, 4)
	
	for i in range(0, spawnNum, 1):
		
		var picking = true
		while picking:
			var n = randi_range(0, 4)
			
			if selectedSpawners.find(n) == -1:
				selectedSpawners.append(n)
				picking = false
	
	for i in selectedSpawners:
		spawners[i].spawnBall()
	
	waveTimer -= 1

func spawnWave():
	for spawner in spawners:
		spawner.spawnBall()
	waveTimer = 4
	timerReset -= 0.2
