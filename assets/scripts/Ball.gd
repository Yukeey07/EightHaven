class_name Ball

extends RigidBody2D

@export_enum("1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15") var BallNumber: int

@export var textures: Array[Texture] = []

var number = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func setBallNum(num: int):
	number = num

func setBallTexture(num: int):
	%Sprite.texture = textures[num]
	if num != 0:
		add_to_group("gameBall", true)
