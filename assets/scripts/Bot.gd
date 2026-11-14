extends Node

var allBalls = Globals.allBalls
var allPockets = Globals.allPockets
var vectorsFromGameBallToBalls = []
var vectorsFromBallstoPockets = []
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ziele()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func ziele():
	vectorsFromGameBallToBalls.clear()
	var gameBall = allBalls[0]
	for i in allBalls.size()-1:
		#Vektoren von Spielball zu Ziel-Ball
		vectorsFromGameBallToBalls.push_back(calculateVectorFromGameBallToBall(gameBall,allBalls[i+1]).length())
		#Vektoren von Allen Bällen zu allen Löchern
		vectorsFromBallstoPockets.push_back(calculateAllVectorsToPocets(allBalls[i+1]))
	print(vectorsFromBallstoPockets)

func calculateVectorFromGameBallToBall(origin: Ball, target: Ball):
	var connectionVector = Vector2(origin.position.x-target.position.x,origin.position.y-target.position.y)
	return connectionVector

func calculateAllVectorsToPocets(origin: Ball):
	var allVectorsFromOrigionToPockets = []
	for i in allPockets.size():
		allVectorsFromOrigionToPockets.push_back(Vector2(origin.position.x-allPockets[i].position.x,origin.position.y-allPockets[i].position.y))
	return allVectorsFromOrigionToPockets
