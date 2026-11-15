extends Sprite2D

@export var isLeft : bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if isLeft:
		$".".flip_h = true
		$Shadow.position = Vector2(32.75,49.0)
		pass
	else:
		$".".flip_h = false
		$Shadow.position = Vector2(-32.5,49.0)
		pass
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
