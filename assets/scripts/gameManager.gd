extends Node2D

const BALL = preload("uid://drnq53lohvym0")
const BOT = preload("res://assets/scenes/bot.tscn")

var allBalls = Globals.allBalls

var index = 1
var is_dragging = false
var drag_offset = Vector2.ZERO
var wait_for_stop = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("test")
	spawnBalls()
	spawnBot()
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
	if event.is_action_pressed("pause_game"):
		toggle_pause(!Globals.isMenu)
	
	if event.is_action_pressed("restart_game"):
		get_tree().change_scene_to_file("res://assets/scenes/game_scene.tscn")
		
	if event is InputEventMouse:
		var white_ball: Ball = allBalls.get(0)
		var global_mouse_pos: Vector2 = get_global_mouse_position()
		
		if white_ball.global_position.distance_to(global_mouse_pos) < 200:
			putQueueAroundWhiteBall(global_mouse_pos)
			
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not wait_for_stop:
		if event.pressed:
			is_dragging = true
			drag_offset = global_position - get_global_mouse_position()
		else:
			is_dragging = false
			var white_ball: Ball = allBalls.get(0)
			white_ball.apply_central_impulse(-((get_global_mouse_position() + drag_offset) * 20))
			$Queue.hide()
			wait_for_stop = true
	elif event is InputEvent:
		if wait_for_stop:
			allBalls = allBalls.filter(func(b): return is_instance_valid(b))
			
			for ball: Ball in allBalls:
				if not ball.sleeping:
					return
					
			wait_for_stop = false
			$Queue.show()

func putQueueAroundWhiteBall(mousePos: Vector2) -> void:
	var white_ball: Ball = allBalls.get(0)
	var direction: Vector2 = (mousePos - white_ball.global_position).normalized()
	
	$Queue.global_position = white_ball.global_position + direction * 800.0
	$Queue.look_at(white_ball.global_position)
	$Queue.rotation_degrees += 90

func _on_pause_pressed() -> void:
	toggle_pause(true)
	pass # Replace with function body.

func _on_resume_pressed() -> void:
	toggle_pause(false)
	pass # Replace with function body.

func toggle_pause(pause : bool):
	Globals.isMenu = pause
	$GameOverlay/Gradient.visible = pause
	get_tree().paused = pause
	$GameOverlay/Controls/BottomControls/Pause.visible = !pause
	$GameOverlay/Controls/BottomControls/Resume.visible = pause
	
	$GameOverlay/Controls/BottomControls/Settings.visible = pause
	$GameOverlay/Controls/BottomControls/Quit.visible = pause

func _on_restart_pressed() -> void:
	get_tree().change_scene_to_file("res://assets/scenes/game_scene.tscn")
	pass # Replace with function body.


func _on_quit_pressed() -> void:
	get_tree().quit()
	pass # Replace with function body.


func _on_settings_pressed() -> void:
	pass # Replace with function body.
