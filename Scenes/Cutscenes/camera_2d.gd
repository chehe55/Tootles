extends Camera2D

@export var randomStrength: float = 50.0
@export var shakeFade: float = 3.0 #smaller value = ends faster 
var rnd = RandomNumberGenerator.new()

var shake_strength: float = 0.0 

		# applyshake
func apply_shake():
	shake_strength = randomStrength
			
			
func _process(delta):  #MEANS TO RUN FUNCTION EVERY FRAME
	if shake_strength > 0:
		shake_strength = lerpf(shake_strength,0,shakeFade * delta) #slowy decreases shake_strength until 0 
		
		offset = randomOffset()
			
func randomOffset() -> Vector2:
	return Vector2(rnd.randf_range(-shake_strength, shake_strength),rnd.randf_range(-shake_strength, shake_strength)) #chooses a random x and y position 

func _on_animated_sprite_2d_frame_changed() -> void:
	if $"../AnimatedSprite2D".frame == 16:
		print("test")
		apply_shake()
