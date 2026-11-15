extends Node2D

const BALL = preload("uid://drnq53lohvym0")
const BOT = preload("res://assets/scenes/bot.tscn")

var allBalls = Globals.allBalls

var index = 1
var is_dragging = false
var drag_offset = Vector2.ZERO
var wait_for_stop = false
var drag_start_pos: Vector2 = Vector2.ZERO
const MAX_DRAG_DISTANCE: float = 500.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("test")
	spawnBalls()
	#spawnBot()
	await get_tree().create_timer(10.0).timeout
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	#check if turn is over
	if ballsMoving():
		Globals.turnOver = true
		print("balls are moving")
	else:
		Globals.turnOver = false
		print("balls are moving")

func ballsMoving():
	allBalls = allBalls.filter(func(b): return is_instance_valid(b))
	
	for i: Ball in allBalls:
		if i.sleeping:
			return false
	return true

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
	print(wait_for_stop)
	var white_ball: Ball = allBalls.get(0)
	if not is_instance_valid(white_ball):
		return

	if event is InputEventMouseMotion:
		var global_mouse_pos: Vector2 = get_global_mouse_position()
		
		if not is_dragging and white_ball.global_position.distance_to(global_mouse_pos) < 200 and not wait_for_stop:
			putQueueAroundWhiteBall(global_mouse_pos)
			
		if is_dragging and not wait_for_stop:
			drag_offset = (drag_start_pos - global_mouse_pos).limit_length(MAX_DRAG_DISTANCE)
			var power = clamp(int(drag_offset.length() / (MAX_DRAG_DISTANCE / 5.0)) + 1, 1, 5)
			$PowerBar.set_power(power)

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not wait_for_stop:
		if event.pressed:
			is_dragging = true
			drag_start_pos = get_global_mouse_position()
			drag_offset = Vector2.ZERO
			$PowerBar.set_power(1)
		elif is_dragging:
			is_dragging = false
			white_ball.sleeping = false # <--- WICHTIG: Sofort aufwecken!
			white_ball.apply_central_impulse(drag_offset * 20)
			$Queue.hide()
			$PowerBar.hide()
			AudioService.create_audio(SoundEffect.SOUND_EFFECT_TYPE.SHOOT)
			wait_for_stop = true

func _physics_process(_delta: float) -> void:
	if wait_for_stop:
		allBalls = allBalls.filter(func(b): return is_instance_valid(b))
		
		for ball: Ball in allBalls:
			if not ball.sleeping:
				return
				
		wait_for_stop = false
		$Queue.show()
		$PowerBar.show()

func putQueueAroundWhiteBall(mousePos: Vector2) -> void:
	var white_ball: Ball = allBalls.get(0)
	var direction: Vector2 = (mousePos - white_ball.global_position).normalized()
	
	$Queue.global_position = white_ball.global_position + direction * 800.0
	$Queue.look_at(white_ball.global_position)
	$Queue.rotation_degrees += 90
	$PowerBar.global_position = $Queue.global_position + Vector2(0, 100)
