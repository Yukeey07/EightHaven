extends Node2D

const BALL = preload("uid://drnq53lohvym0")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawnBalls()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func spawnBalls():
	var target_pos : Vector2 = Vector2(0,0)
	for i in 15:
		var ball = BALL.instantiate()
		ball.setBallTexture(i)
		ball.position = target_pos
		add_child(ball)
		print(target_pos)
		target_pos += Vector2(0,125)
	pass
