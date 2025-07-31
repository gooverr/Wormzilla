extends Area2D

var speed = 350
var turn_speed = 180
var turn = 0.0
var turn_smoothing_value = 0.1


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	await get_tree().create_timer(1).timeout
	position -= transform.y * speed * delta
	await get_tree().create_timer(1.5).timeout
	turn = lerp(turn, Input.get_axis("player_left","player_right"), turn_smoothing_value)
	rotation_degrees += turn * turn_speed * delta
	
	 
	#if Input.is_action_pressed("player_down") and position.y < 600:
		#position.y += moveSpeed
	#if Input.is_action_pressed("player_up") and position.y > 50:
		#position.y -= moveSpeed
	#if Input.is_action_pressed("player_right") and position.x < 1152:
		#position.x += moveSpeed
	#if Input.is_action_pressed("player_left") and position.x > 50:
		#position.x -= moveSpeed
		
