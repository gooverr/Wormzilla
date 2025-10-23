extends Area2D

var speed = 1
var turn_speed = 300.0 # degrees per second
var turn_smoothing_value = 0.1
var lifetime = 1.0
var lengthratio = 0.1
var sizeamount = 1.0
var zoom = 0.5
@export var default_trail_scale: Vector2 = Vector2(1, 1)

@onready var particles : GPUParticles2D = $GPUParticles2D
@onready var camera : Camera2D = $Camera2D
@onready var collision : CollisionShape2D = $CollisionShape2D
@onready var character : Sprite2D = $Sprite2D

var face2 = preload("res://Textures/Character.png")
var face1 = preload("res://Textures/Character3.png")
var goo1 = preload("res://Textures/CharacterTeethGoo1.png")
var goo2 = preload("res://Textures/CharacterTeethGoo2.png")
var goo3 = preload("res://Textures/CharacterTeethGoo3.png")

var score_manager = null

func _ready():
	reset_particles()
	score_manager = get_node("/root/game/Score")  # Adjust path to your score UI node
	change_face_later()  # ✅ moved delayed texture/speed change here (runs once)

func reset_particles():
	particles.scale = default_trail_scale
	particles.lifetime = 1.0
	particles.amount_ratio = 1.0

	if particles.process_material:
		particles.process_material.scale = Vector2(1, 1)
		particles.process_material.color = Color(1, 1, 1, 1)

	print("Particles fully reset!")

func _process(delta):
	var mouse_pos = get_global_mouse_position()
	var to_mouse = (mouse_pos - position)

	if to_mouse.length() < 5:
		return
	
	var direction = to_mouse.normalized()
	var target_angle = rad_to_deg(direction.angle()) - 90
	var current_angle = rotation_degrees

	var angle_diff = wrapf(target_angle - current_angle, -180, 180)
	var turn_direction = sign(angle_diff)

	var smoothed_turn = lerp(turn_direction, 0.0, turn_smoothing_value)
	rotation_degrees += smoothed_turn * turn_speed * delta

	position += transform.y * speed * delta

# ✅ runs once (instead of every frame) to change to face2 after a delay
func change_face_later() -> void:
	await get_tree().create_timer(1.5).timeout
	character.texture = face2
	speed = 400

func grow():
	if sizeamount <= 5.0:
		sizeamount += 0.1
		turn_speed -= 1.5
		lifetime += 0.1
		zoom -= 0.005
		
		print(sizeamount)

		# ✅ fixed texture order — biggest → smallest
		if sizeamount >= 5.0:
			character.texture = goo3
		elif sizeamount >= 3.7:
			character.texture = goo2
		elif sizeamount >= 2.3:
			character.texture = goo1

	# ✅ keep scoring etc.
	if score_manager:
		score_manager.increase_score(1)

	particles.lifetime = lifetime
	particles.amount_ratio = 1.0
	if particles.amount_ratio <= 15:
		particles.amount_ratio += lengthratio
	particles.process_material.scale = Vector2(sizeamount, sizeamount)

	character.scale = Vector2(sizeamount, sizeamount)
	collision.scale = Vector2(sizeamount, sizeamount)
	camera.zoom = Vector2(zoom, zoom)
