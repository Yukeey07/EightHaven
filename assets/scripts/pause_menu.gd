extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause_game"):
		get_tree().paused = !get_tree().paused
		$".".visible = !$".".visible
	pass

func _on_continue_pressed() -> void:
	get_tree().paused = false
	$".".hide()
	pass # Replace with function body.

func _on_settings_pressed() -> void:
	pass # Replace with function body.

func _on_quit_pressed() -> void:
	get_tree().quit()
	pass # Replace with function body.
