extends Node

var allBalls = Globals.allBalls
var allPockets = Globals.Pockets
var vectorFromGameBallToBalls = []
var vectorFromBallstoPockets = []
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ziele()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func ziele():
	vectorFromGameBallToBalls.clear()
	var gameBall = allBalls[0]
	for i in allBalls.size()-1:
		#Vektoren von Spielball zu Ziel-Ball
		vectorFromGameBallToBalls.push_back(rechneVerbindung(gameBall,allBalls[i+1]).length())
		#Vektoren von Allen Bällen zu allen Löchern
		for j in allPockets.size():
			vectorFromBallstoPockets.push_back(rechneVerbindung(allBalls[i+1],allPockets[i].length()))

func rechneVerbindung(origin: Ball, target: Ball):
	var connectionVector = Vector2(origin.position.x-target.position.x,origin.position.y-target.position.y)
	return connectionVector
