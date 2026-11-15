class_name Ball

extends RigidBody2D

@export_enum("1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15") var BallNumber: int

@export var textures: Array[Texture] = []
@export var stop_threshold: float = 60

var number = 0

var speedup = false
var timer := Timer.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_child(timer)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func setBallTexture(num: int):
	%Sprite.texture = textures[num]
	number = num
	if num != 0:
		add_to_group("gameBall", true)
		
func _integrate_forces(state: PhysicsDirectBodyState2D):#
	if speedup:
		state.linear_velocity = state.linear_velocity + Vector2(2, 2)
		state.angular_velocity += 2
	
	if state.linear_velocity.length() < stop_threshold:
		state.linear_velocity = Vector2.ZERO
		state.angular_velocity = 0.0
		sleeping = true


func _on_body_entered(body: Node) -> void:
	if not Globals.shootSoundPlayed:
		AudioService.create_audio(SoundEffect.SOUND_EFFECT_TYPE.SHOOT)
		Globals.shootSoundPlayed = true
		
func makeVeryBouncy():
	physics_material_override.bounce = 1
	physics_material_override.friction = 0.5
	mass = 2.5
	
func resetPhysics():
	physics_material_override.bounce = 0.5
	physics_material_override.friction = 1.5
	mass = 5
	
func setSpeedUp(seconds: float):
	timer.wait_time = seconds
	timer.one_shot = true
	timer.timeout.connect(_on_timer_timeout)
	timer.start()
	speedup = true
	pass
	
func _on_timer_timeout():
	speedup = false
	pass
