extends Node2D

var allBlockaden = []
var activeBlockaden = []
var maxBlockaden = 5

var rng : RandomNumberGenerator

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func getBlockaden() -> Array:
	return get_children()

func enableRandomBlockaden(blocks : Array):
	rng = RandomNumberGenerator.new()
	for b in allBlockaden:
			var num = rng.randf_range(0, 6.0)
			if num == 3:
				activeBlockaden.append(b)
				b.show()
			pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
