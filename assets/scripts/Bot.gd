extends Node

var allBalls = Globals.allBalls
var allPockets = Globals.allPockets
var vectorsFromGameBallToBalls = []
var vectorsFromBallstoPockets = []
var possibleShots = []
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ziele()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func ziele():
	vectorsFromGameBallToBalls.clear()
	vectorsFromBallstoPockets.clear()
	generateVectorsForAiming()
	checkVectors()

func calculateVectorFromGameBallToBall(origin: Ball, target: Ball):
	var connectionVector = Vector2(origin.position.x-target.position.x,origin.position.y-target.position.y)
	return connectionVector

func calculateAllVectorsToPocets(origin: Ball):
	var allVectorsFromOrigionToPockets = []
	for i in allPockets.size():
		allVectorsFromOrigionToPockets.push_back(Vector2(origin.position.x-allPockets[i].position.x,origin.position.y-allPockets[i].position.y))
	return allVectorsFromOrigionToPockets

func generateVectorsForAiming():
	var gameBall = allBalls[0]
	for i in allBalls.size()/2-1:
		#Vektoren von Spielball zu Ziel-Ball
		vectorsFromGameBallToBalls.push_back(calculateVectorFromGameBallToBall(gameBall,allBalls[i+8]).length())
		#Vektoren von Allen Bällen zu allen Löchern
		vectorsFromBallstoPockets.push_back(calculateAllVectorsToPocets(allBalls[i+8]))
	print(vectorsFromBallstoPockets)

func checkVectors():
	for i in vectorsFromGameBallToBalls:
		for j in vectorsFromBallstoPockets:
			# prüfen ob für x: + und + oder - und - .und für y: + und + oder - und -
			pass
			if(checkDirection(vectorsFromGameBallToBalls[i],vectorsFromBallstoPockets[j])):
				possibleShots.push_back(calculateShot(vectorsFromGameBallToBalls[i],vectorsFromBallstoPockets[j]))


func checkDirection(vector1: Vector2, vector2: Vector2):
	if(vector1.x<0 and vector2.x<0):
		if(vector1.y<0 and vector2.y<0):
			return true
		if(vector1.y>0 and vector2.y>0):
			return true
	if(vector1.x>0 and vector2.x>0):
		if(vector1.y<0 and vector2.y<0):
			return true
		if(vector1.y>0 and vector2.y>0):
			return true
	return false

func calculateShot(vector1: Vector2, vector2: Vector2):
	var resultVector = Vector2()
	#vektor von spielball zum zielball um die länge von vektor von zielball zur tasche verlängern
	var straightVector = vector1+((vector1/vector1.length())*vector2.length())
	var addedVector = vector1+vector2
	#unterschied zwischen jenem vektor und dem vektor vom spielball zum zielball und von da zur tasche bestimmen
	if(straightVector.x<addedVector.x):
		if(straightVector.y<addedVector.y):
			resultVector = Vector2(vector1.x*1.03,vector1.y*1.03)
		if(straightVector.y>addedVector.y):
			resultVector = Vector2(vector1.x*1.03,vector1.y*-1.03)
	if(straightVector.x>addedVector.x):
		if(straightVector.y<addedVector.y):
			resultVector = Vector2(vector1.x*-1.03,vector1.y*1.03)
		if(straightVector.y>addedVector.y):
			resultVector = Vector2(vector1.x*-1.03,vector1.y*-1.03)
	#je nach unterschied werte von vektor von spielball zu zielball verändern.
	return resultVector
