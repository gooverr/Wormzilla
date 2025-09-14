extends Area2D

@export var hunger_fill_amount: float = 13
@export var turn_speed: float = 2.0
@export var max_distance: float = 1800.0  # Despawn if farther than this from player
@export var fade_in_time: float = 1
@export var fade_out_time: float = 0.3


const FOOD_SPRITES = [
	preload("res://Textures/bug1.png"),
	preload("res://Textures/bug2.png"),
	preload("res://Textures/bug3.png"),
	preload("res://Textures/bug4.png"),
	preload("res://Textures/Ant1.png")
]

# Preload your sounds here:
const EAT_SOUNDS = [
	preload("res://Sounds/Eat.wav"),
	preload("res://Sounds/Eat2.wav"),
	preload("res://Sounds/Eat3.wav")
]

var player: Node
var hunger_bar
var sprite_node: Sprite2D
@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer
var fading_out := false  # Prevents double fade calls

func _ready():
	player = get_tree().get_first_node_in_group("Player")
	hunger_bar = get_tree().get_first_node_in_group("HungerBar")
	sprite_node = $Sprite2D

	# Assign random sprite
	if sprite_node and FOOD_SPRITES.size() > 0:
		sprite_node.texture = FOOD_SPRITES[randi() % FOOD_SPRITES.size()]

	# Start invisible for fade-in
	if sprite_node:
		sprite_node.modulate.a = 0.0
		var tween = create_tween()
		tween.tween_property(sprite_node, "modulate:a", 1.0, fade_in_time)

	# Connect touch detection
	if not is_connected("area_entered", Callable(self, "_on_area_entered")):
		connect("area_entered", Callable(self, "_on_area_entered"))

func _process(delta):
	if not player or fading_out:
		return

	var direction = (global_position - player.global_position).normalized()
	global_position += direction * 100 * delta

	# Smooth turning
	if direction.length() > 0:
		var target_angle = direction.angle()
		rotation = lerp_angle(rotation, target_angle, turn_speed * delta)

	# Despawn if too far
	if global_position.distance_to(player.global_position) > max_distance:
		start_fade_out()

func _on_area_entered(area):
	if fading_out:
		return

	if area.is_in_group("Player"):
		if hunger_bar and hunger_bar.has_method("add_hunger"):
			hunger_bar.call("add_hunger", hunger_fill_amount)
			
			# Play a random eating sound
		audio_player.stream = EAT_SOUNDS[randi() % EAT_SOUNDS.size()]
		audio_player.play()
			
		start_fade_out()
		area.grow()

func start_fade_out():
	if fading_out or not sprite_node:
		return
	fading_out = true
	var tween = create_tween()
	tween.tween_property(sprite_node, "modulate:a", 0.0, fade_out_time)
	tween.connect("finished", Callable(self, "queue_free"))
