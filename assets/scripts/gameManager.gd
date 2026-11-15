extends Node2D

const BALL = preload("uid://drnq53lohvym0")
const BOT = preload("res://assets/scenes/bot.tscn")
const BLOCKADE = preload("uid://0jfp5sv6yhj3")
const BOUNCE_PAD = preload("uid://bajf53tdbklkg")

@export var bounce_pad_amount: int = 3

var allBalls: Array = []
var allBouncePads: Array = []

var index = 1
var is_dragging = false
var drag_offset = Vector2.ZERO
var wait_for_stop = false
var drag_start_pos: Vector2 = Vector2.ZERO
const MAX_DRAG_DISTANCE: float = 500.0
var bot = null

var rng: RandomNumberGenerator

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.allBalls.clear()
	Globals.allBlockages.clear()
	allBouncePads.clear()
	allBalls = Globals.allBalls

	rng = RandomNumberGenerator.new()
	AudioService.create_audio(SoundEffect.SOUND_EFFECT_TYPE.BACKGROUND_MUSIC_1)
	spawnBalls()
	spawnBlockades(4)
	spawnBouncePads(bounce_pad_amount)
	spawnBot()
	await get_tree().create_timer(10.0).timeout


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Globals.allBalls.size() == 0:
		$Win.show()
		pass
	
	if not wait_for_stop and Globals.turn == Globals.Players.BOT:
		if allBalls.is_empty() or not is_instance_valid(allBalls[0]):
			return
		var white_ball: Ball = allBalls[0]
		white_ball.sleeping = false
		bot.botShoot()
		$Queue.hide()
		$PowerBar.hide()
		Globals.shootSoundPlayed = false
		wait_for_stop = true


func ballsMoving() -> bool:
	for i: Ball in allBalls:
		if is_instance_valid(i) and i.sleeping:
			return false
	return true


func spawnBalls() -> void:
	var target_pos: Vector2 = Vector2(0, -805)
	var ball = BALL.instantiate()
	allBalls.push_back(ball)
	ball.setBallTexture(0)
	# One Ball is 115
	ball.position = target_pos + Vector2(0, 1725)
	add_child(ball)
	for i in 5:
		spawnBallRow(target_pos, i + 1)
		target_pos += Vector2(62.5, -115)
	index = 1


func spawnBallRow(startPos: Vector2, length: int) -> void:
	for i in length:
		var ball = BALL.instantiate()
		allBalls.push_back(ball)
		ball.setBallTexture(index)
		index += 1
		ball.position = startPos
		add_child(ball)
		startPos += Vector2(-125, 0)


func spawnBlockades(amount: int) -> void:
	for i in amount:
		var blockage = BLOCKADE.instantiate()
		var num = rng.randi_range(0, 3)
		print(num)
		
		if num == 0: # TOP LEFT
			var target_pos = findValidPosition(-1060.0, -1.0)
			blockage.position = target_pos
			blockage.isLeft = true
		
		elif num == 1: # TOP RIGHT
			var target_pos = findValidPosition(1060.0, -1.0)
			blockage.position = target_pos
			blockage.isLeft = false
		
		elif num == 2: # BOTTOM LEFT
			var target_pos = findValidPosition(-1060.0, 1.0)
			blockage.position = target_pos
			blockage.isLeft = true
		
		elif num == 3: # BOTTOM RIGHT
			var target_pos = findValidPosition(1060.0, 1.0)
			blockage.position = target_pos
			blockage.isLeft = false
		
		Globals.allBlockages.append(blockage)
		$Blockades.add_child(blockage)


func spawnBouncePads(amount: int) -> void:
	for i in amount:
		var target_pos = findValidBouncePadPosition()
		if target_pos != Vector2.INF:
			var pad = BOUNCE_PAD.instantiate()
			pad.position = target_pos
			allBouncePads.append(pad)
			# Falls du einen Container-Node wie $BouncePads hast, kannst du auch $BouncePads.add_child(pad) nutzen
			add_child(pad)


func findValidBouncePadPosition() -> Vector2:
	var attempts := 0
	while attempts < 50:
		# Spielfeld-Bereich mit Sicherheitsabstand zu den Außenwänden (-1060 bis 1060)
		var pos := Vector2(rng.randf_range(-750.0, 750.0), rng.randf_range(-1750.0, 1750.0))
		var valid := true
		
		# 1. Abstand zu anderen Bounce Pads prüfen
		for pad in allBouncePads:
			if is_instance_valid(pad) and pad.position.distance_to(pos) <= 400.0:
				valid = false
				break
		
		# 2. Abstand zu Blockaden prüfen
		if valid:
			for ab in Globals.allBlockages:
				if is_instance_valid(ab) and ab.position.distance_to(pos) <= 500.0:
					valid = false
					break
		
		# 3. Abstand zu den gespawnten Bällen prüfen (damit kein Ball auf einem Pad spawnt)
		if valid:
			for ball in allBalls:
				if is_instance_valid(ball) and ball.position.distance_to(pos) <= 350.0:
					valid = false
					break
					
		if valid:
			return pos
		attempts += 1
		
	return Vector2.INF


func findValidPosition(x_pos: float, y_sign: float) -> Vector2:
	var pos := Vector2(x_pos, rng.randf_range(300.0, 2000.0) * y_sign)
	var attempts := 0
	
	while attempts < 20:
		var valid := true
		for ab in Globals.allBlockages:
			if is_instance_valid(ab) and ab.position.distance_to(pos) <= 500.0:
				valid = false
				break
		if valid:
			return pos
		pos = Vector2(x_pos, rng.randf_range(300.0, 2000.0) * y_sign)
		attempts += 1
	
	return pos


func spawnBot() -> void:
	bot = BOT.instantiate()
	add_child(bot)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause_game"):
		toggle_pause(!Globals.isMenu)
	
	if event.is_action_pressed("restart_game"):
		get_tree().paused = false
		get_tree().change_scene_to_file("res://assets/scenes/main_menu.tscn")
		return
		
	if allBalls.is_empty():
		return
	var white_ball: Ball = allBalls[0]
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
			white_ball.sleeping = false
			white_ball.apply_central_impulse(drag_offset * 20)
			Globals.turn = Globals.Players.BOT
			$Queue.hide()
			$PowerBar.hide()
			Globals.shootSoundPlayed = false
			wait_for_stop = true


func _physics_process(_delta: float) -> void:
	if wait_for_stop:
		Globals.allBalls = Globals.allBalls.filter(func(b): return is_instance_valid(b))
		allBalls = Globals.allBalls

		for ball: Ball in allBalls:
			if not ball.sleeping:
				return

		wait_for_stop = false
		$Queue.show()
		$PowerBar.show()


func putQueueAroundWhiteBall(mousePos: Vector2) -> void:
	if allBalls.is_empty() or not is_instance_valid(allBalls[0]):
		return
	var white_ball: Ball = allBalls[0]
	var direction: Vector2 = (mousePos - white_ball.global_position).normalized()

	$Queue.global_position = white_ball.global_position + direction * 800.0
	$Queue.look_at(white_ball.global_position)
	$Queue.rotation_degrees += 90
	$PowerBar.global_position = $Queue.global_position + Vector2(0, 100)


func _on_pause_pressed() -> void:
	toggle_pause(true)


func _on_resume_pressed() -> void:
	toggle_pause(false)


func toggle_pause(pause: bool) -> void:
	Globals.isMenu = pause
	$GameOverlay/Gradient.visible = pause
	get_tree().paused = pause
	$GameOverlay/Controls/BottomControls/Pause.visible = !pause
	$GameOverlay/Controls/BottomControls/Resume.visible = pause
	$GameOverlay/Controls/BottomControls/Settings.visible = pause
	$GameOverlay/Controls/BottomControls/Quit.visible = pause


func _on_restart_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://assets/scenes/game_scene.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_settings_pressed() -> void:
	pass
