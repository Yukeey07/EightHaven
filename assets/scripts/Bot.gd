extends Node

var allBalls = Globals.allBalls
var vectorToBalls = []
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ziele()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func ziele():
	vectorToBalls.clear()
	var gameBall = allBalls[0]
	for i in allBalls.size()-1:
		vectorToBalls.push_back(rechneVerbindung(gameBall,allBalls[i+1]).length())
	vectorToBalls.sort()
	print(vectorToBalls)

func rechneVerbindung(gameBall: Ball, aimBall: Ball):
	var connectionVector = Vector2(gameBall.position.x-aimBall.position.x,gameBall.position.y-aimBall.position.y)
	return connectionVector
