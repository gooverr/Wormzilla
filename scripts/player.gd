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

var score_manager = null

func _ready():
	reset_particles()
	score_manager = get_node("/root/game/Score")  # Adjust path to your score UI node

func reset_particles():
	# Reset basic particle properties
	particles.scale = default_trail_scale
	particles.lifetime = 1.0
	particles.amount_ratio = 1.0

	# ✅ Reset the process material values
	if particles.process_material:
		particles.process_material.scale = Vector2(1, 1)  # Original scale
		particles.process_material.color = Color(1, 1, 1, 1)  # Reset to fully visible white

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

	await get_tree().create_timer(1.5).timeout
	character.texture = face2
	speed = 400

func grow():
	if sizeamount <= 5.0:
		sizeamount += 0.1
		turn_speed -= 1.5
		lifetime += 0.1
		zoom -= 0.005
		if score_manager:
			score_manager.increase_score(1)

	particles.lifetime = lifetime
	particles.amount_ratio = 1.0
	if particles.amount_ratio <= 15:
		particles.amount_ratio += lengthratio
	particles.process_material.scale.x = sizeamount
	particles.process_material.scale.y = sizeamount
	character.scale.x = sizeamount
	character.scale.y = sizeamount
	collision.scale.x = sizeamount
	collision.scale.y = sizeamount
	camera.zoom.x = zoom
	camera.zoom.y = zoom
