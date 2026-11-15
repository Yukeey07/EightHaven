extends Node

var gameBall: Ball
var meaningfulBalls: Array[Ball] = []
var vectorsFromGameBallToBalls: Array[Vector2] = []
var vectorsFromBallstoPockets: Array = []
var possibleShots: Array[Vector2] = []


func _ready() -> void:
	pass


func botShoot() -> bool:
	var bestShot = findBestShot()
	print(bestShot)
	if bestShot != Vector2.ZERO:
		shoot(bestShot)
	Globals.turn = Globals.Players.PLAYER
	return true


func findBestShot() -> Vector2:
	# Clear ALL arrays every turn so freed or old ball references never persist
	meaningfulBalls.clear()
	vectorsFromGameBallToBalls.clear()
	vectorsFromBallstoPockets.clear()
	possibleShots.clear()
	
	if Globals.allBalls.is_empty():
		return Vector2.ZERO
		
	gameBall = Globals.allBalls[0]
	if not is_instance_valid(gameBall):
		return Vector2.ZERO
		
	getAllMeaningfulBalls()
	if meaningfulBalls.is_empty():
		return Vector2.ZERO
		
	generateVectorsForAiming()
	checkVectors()
	
	# Fallback: if no direct pocket angle was found, shoot directly at the first valid target ball
	if possibleShots.is_empty():
		return calculateVectorFromGameBallToBall(gameBall, meaningfulBalls[0])
		
	possibleShots.sort_custom(compareVectorLength)
	return possibleShots[0]


func getAllMeaningfulBalls() -> void:
	for ball in Globals.allBalls:
		if not is_instance_valid(ball):
			continue
		if ball.number > 8:
			meaningfulBalls.push_back(ball)
			
	if meaningfulBalls.is_empty():
		for ball in Globals.allBalls:
			if is_instance_valid(ball) and ball.number == 8:
				meaningfulBalls.push_back(ball)


func compareVectorLength(a: Vector2, b: Vector2) -> bool:
	return a.length() < b.length()


func calculateVectorFromGameBallToBall(origin: Ball, target: Ball) -> Vector2:
	return Vector2(origin.position.x - target.position.x, origin.position.y - target.position.y)


func calculateAllVectorsToPockets(origin: Ball) -> Array[Vector2]:
	var allVectorsFromOriginToPockets: Array[Vector2] = []
	for pocket in Globals.allPockets:
		if is_instance_valid(pocket):
			allVectorsFromOriginToPockets.push_back(
				Vector2(origin.position.x - pocket.position.x, origin.position.y - pocket.position.y)
			)
	return allVectorsFromOriginToPockets


func generateVectorsForAiming() -> void:
	for ball in meaningfulBalls:
		if not is_instance_valid(ball):
			continue
		# Vektoren von Spielball zu Ziel-Ball
		vectorsFromGameBallToBalls.push_back(calculateVectorFromGameBallToBall(gameBall, ball))
		# Vektoren von allen Bällen zu allen Löchern
		vectorsFromBallstoPockets.push_back(calculateAllVectorsToPockets(ball))
	print(vectorsFromBallstoPockets)


func checkVectors() -> void:
	for i in vectorsFromGameBallToBalls.size():
		for j in vectorsFromBallstoPockets[i].size():
			# Prüfen ob für x: + und + oder - und -, und für y: + und + oder - und -
			if checkDirection(vectorsFromGameBallToBalls[i], vectorsFromBallstoPockets[i][j]):
				possibleShots.push_back(
					calculateShot(vectorsFromGameBallToBalls[i], vectorsFromBallstoPockets[i][j])
				)


func checkDirection(vector1: Vector2, vector2: Vector2) -> bool:
	if vector1.x < 0 and vector2.x < 0:
		if vector1.y < 0 and vector2.y < 0:
			return true
		if vector1.y > 0 and vector2.y > 0:
			return true
	if vector1.x > 0 and vector2.x > 0:
		if vector1.y < 0 and vector2.y < 0:
			return true
		if vector1.y > 0 and vector2.y > 0:
			return true
	return false


func calculateShot(vector1: Vector2, vector2: Vector2) -> Vector2:
	var resultVector = Vector2.ZERO
	if vector1.length() == 0:
		return resultVector
		
	# Vektor von Spielball zum Zielball um die Länge von Vektor von Zielball zur Tasche verlängern
	var straightVector = vector1 + ((vector1 / vector1.length()) * vector2.length())
	var addedVector = vector1 + vector2
	
	# Unterschied zwischen jenem Vektor und dem Vektor vom Spielball zum Zielball und von da zur Tasche bestimmen
	if straightVector.x < addedVector.x:
		if straightVector.y < addedVector.y:
			resultVector = Vector2(vector1.x * 1.03, vector1.y * 1.03)
		elif straightVector.y > addedVector.y:
			resultVector = Vector2(vector1.x * 1.03, vector1.y * -1.03)
	elif straightVector.x > addedVector.x:
		if straightVector.y < addedVector.y:
			resultVector = Vector2(vector1.x * -1.03, vector1.y * 1.03)
		elif straightVector.y > addedVector.y:
			resultVector = Vector2(vector1.x * -1.03, vector1.y * -1.03)
			
	return resultVector

func shoot(vect: Vector2) -> void:
	if is_instance_valid(gameBall):
		gameBall.apply_central_impulse(vect * 20)
