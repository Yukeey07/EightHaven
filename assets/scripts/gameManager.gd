extends Node2D

const BALL = preload("uid://drnq53lohvym0")

var allBalls = Globals.allBalls

var index = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("test")
	spawnBalls()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func spawnBalls():
	var target_pos : Vector2 = Vector2(0,-805)
	var ball = BALL.instantiate()
	allBalls.push_back(ball)
	ball.setBallTexture(0)
	# One Ball is 115
	ball.position = target_pos + Vector2(0,1725)
	add_child(ball)
	for i in 5:
		spawnBallRow(target_pos, i + 1)
		target_pos += Vector2(62.5,-115)
	index = 1
	print(allBalls)
	pass

func spawnBallRow(startPos : Vector2, length: int):
	for i in length:
		var ball = BALL.instantiate()
		allBalls.push_back(ball)
		ball.setBallTexture(index)
		index += 1
		ball.position = startPos
		add_child(ball)
		startPos += Vector2(-125,0)
	pass

func getallBalls():
	return allBalls
