extends Area2D

var speed = 1
var turn_speed = 300.0 # degrees per second
var turn_smoothing_value = 0.1
var lifetime = 1.0
var lengthratio = 0.1
var sizeamount = 1.0
var zoom = 0.5

@onready var particles : GPUParticles2D = $GPUParticles2D
@onready var camera : Camera2D = $Camera2D
@onready var collision : CollisionShape2D = $CollisionShape2D
@onready var character : Sprite2D = $Sprite2D

func _process(delta):
	var mouse_pos = get_global_mouse_position()
	var to_mouse = (mouse_pos - position)

	# If mouse is too close, stop moving
	if to_mouse.length() < 5:
		return
	
	var direction = to_mouse.normalized()

	# Target angle in degrees
	var target_angle = rad_to_deg(direction.angle()) - 90  # +90 if sprite points up
	var current_angle = rotation_degrees

	# Find shortest rotation direction (-1, 0, 1)
	var angle_diff = wrapf(target_angle - current_angle, -180, 180)
	var turn_direction = sign(angle_diff)

	# Apply turn smoothing
	var smoothed_turn = lerp(turn_direction, 0.0, turn_smoothing_value)

	# Rotate towards target
	rotation_degrees += smoothed_turn * turn_speed * delta

	# Move forward towards mouse
	position += transform.y * speed * delta
	await get_tree().create_timer(1.5).timeout
	speed = 400

func grow():
	#if lifetime < 4.0:
	#	lifetime += 0.2
	if sizeamount <= 5.0:
		sizeamount += 0.1#0.2
		turn_speed -= 1.5#3
		lifetime += 0.1#0.2
		zoom -= 0.005#0.01
		print(sizeamount,': size')
		print(turn_speed,': turn speed')
		print(lifetime,': lifetime')
		print(zoom,': zoom')
	#if zoom >= 0.3:	
	#	zoom -= 0.01
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
	
