extends Control

#signal power_selected(_power: int)

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

const MAX_POWER = 5

func _ready() -> void:
	animated_sprite_2d.pause()
	animated_sprite_2d.frame = 0

func set_power(power):
	animated_sprite_2d.frame = power
