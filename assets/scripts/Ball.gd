extends Node

@export_enum("1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15") var BallNumber: int

@export var textures: Array[Texture] = []

@onready var sprite: Sprite2D = $Sprite

var number = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite.texture = textures[BallNumber]
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
