extends Node

var allBalls = Globals.allBalls
var allPockets = Globals.allPockets
var gameBall: Ball = allBalls[0]
var meaningfulBalls = []
var vectorsFromGameBallToBalls = []
var vectorsFromBallstoPockets = []
var possibleShots = []
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func botShoot():
	var bestShot = findBestShot()
	print(bestShot)
	shoot(bestShot)
	Globals.turn = Globals.Players.PLAYER
	return true


func findBestShot():
	getAllMeaningfulBalls()
	vectorsFromGameBallToBalls.clear()
	vectorsFromBallstoPockets.clear()
	generateVectorsForAiming()
	checkVectors()
	possibleShots.sort_custom(compareVectorLength)
	return possibleShots[0]

func getAllMeaningfulBalls():
	for i in allBalls:
		if i.number > 8:
			meaningfulBalls.push_back(i)
	if meaningfulBalls.is_empty():
		for i in allBalls:
			if i.number == 8:
				meaningfulBalls.push_back(i)

func compareVectorLength(a: Vector2,b: Vector2):
	if(a.length()<b.length()):
		return true
	return false

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
	for i in meaningfulBalls.size():
		#Vektoren von Spielball zu Ziel-Ball
		vectorsFromGameBallToBalls.push_back(calculateVectorFromGameBallToBall(gameBall,meaningfulBalls[i]))
		#Vektoren von Allen Bällen zu allen Löchern
		vectorsFromBallstoPockets.push_back(calculateAllVectorsToPocets(meaningfulBalls[i]))
	print(vectorsFromBallstoPockets)

func checkVectors():
	for i in vectorsFromGameBallToBalls.size():
		for j in vectorsFromBallstoPockets[i].size():
			# prüfen ob für x: + und + oder - und - .und für y: + und + oder - und -
			if(checkDirection(vectorsFromGameBallToBalls[i],vectorsFromBallstoPockets[i][j])):
				possibleShots.push_back(calculateShot(vectorsFromGameBallToBalls[i],vectorsFromBallstoPockets[i][j]))


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

func shoot(vect: Vector2):
	gameBall.apply_central_impulse(vect*2)
	pass
