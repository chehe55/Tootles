class_name ShieldIndicator extends Node2D

@onready var animation_player: AnimationPlayer = $ShieldMask/ColorRect/AnimationPlayer

func startShortCDAnim():
	animation_player.play("shortCD")

func startLongCDAnim():
	animation_player.play("longCD")
