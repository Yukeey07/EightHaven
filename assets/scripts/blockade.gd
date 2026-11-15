extends Sprite2D

@export var isLeft : bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if isLeft:
		$".".flip_h = true
		pass
	else:
		$".".flip_h = false
		pass
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
