extends Node2D

const BALL = preload("uid://drnq53lohvym0")
const BOT = preload("res://assets/scenes/bot.tscn")

var allBalls = Globals.allBalls

var index = 1
var is_dragging = false
var drag_offset = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("test")
	spawnBalls()
	spawnBot()
	await get_tree().create_timer(10.0).timeout
	print(Globals.allPockets)
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

func spawnBot():
	var bot = BOT.instantiate()
	add_child(bot)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouse:
		var white_ball: Ball = allBalls.get(0)
		var global_mouse_pos: Vector2 = get_global_mouse_position()
		
		if white_ball.global_position.distance_to(global_mouse_pos) < 200:
			putQueueAroundWhiteBall(global_mouse_pos)
			
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			is_dragging = true
			drag_offset = global_position - get_global_mouse_position()
		else:
			is_dragging = false
			var white_ball: Ball = allBalls.get(0)
			white_ball.apply_central_impulse(-((get_global_mouse_position() + drag_offset) * 20))
		

func putQueueAroundWhiteBall(mousePos: Vector2) -> void:
	var white_ball: Ball = allBalls.get(0)
	var direction: Vector2 = (mousePos - white_ball.global_position).normalized()
	
	$Queue.global_position = white_ball.global_position + direction * 800.0
	$Queue.look_at(white_ball.global_position)
	$Queue.rotation_degrees += 90
