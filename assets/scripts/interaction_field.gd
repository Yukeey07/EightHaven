extends Area2D

var interactedBall : Ball

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("gameBall"):
		print("DB : BALL HIT THE POCKET")
		body.queue_free()
		pass
	pass # Replace with function body.


func _on_body_exited(body: Node2D) -> void:
	print(body.get_parent())
	if body.is_in_group("gameBall"):
		pass
	pass # Replace with function body.
