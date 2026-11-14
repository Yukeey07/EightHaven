extends Area2D

var interactedBall : Ball

@export var is_pocket : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CanvasLayer/PocketHitBanner.hide()
	if is_pocket:
		Globals.allPockets.push_back(self)
		pass
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("gameBall"):
		if is_pocket:
			$CanvasLayer/PocketHitBanner/Label.text = "Ball " + str(body.number) + " is Out!"
			body.queue_free()
			$CanvasLayer/PocketHitBanner.show()
			await get_tree().create_timer(5.0).timeout
			$CanvasLayer/PocketHitBanner.hide()
			pass
		pass
	pass # Replace with function body.


func _on_body_exited(body: Node2D) -> void:
	print(body.get_parent())
	if body.is_in_group("gameBall"):
		pass
	pass # Replace with function body.
