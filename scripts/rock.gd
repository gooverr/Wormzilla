extends Area2D

@export var hunger_fill_amount: float = -25
@export var fade_in_time: float = 1.0
@export var fade_out_time: float = 0.3
@export var shake_intensity: float = 20.0
@export var shake_duration: float = 0.3

const ROCK_SPRITES = [
	preload("res://Textures/Rockv3.1.png"),
	preload("res://Textures/Rockv3.2.png"),
	preload("res://Textures/Rockv3.3.png")
]

const ROCK_SOUNDS = [
	preload("res://Sounds/Hurt1.wav"),
	preload("res://Sounds/Hurt2.wav"),
	preload("res://Sounds/Hurt3.wav"),
	preload("res://Sounds/Hurt4.wav"),
	preload("res://Sounds/Hurt5.wav")
]

var player: Node
var hunger_bar
var camera: Camera2D
@onready var sprite_node: Sprite2D = $Sprite2D
@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer
var fading_out := false

func _ready():
	player = get_tree().get_first_node_in_group("Player")
	hunger_bar = get_tree().get_first_node_in_group("HungerBar")
	camera = get_tree().get_first_node_in_group("MainCamera") # <-- Add your Camera2D to this group!

	# ✅ Assign random sprite
	if sprite_node and ROCK_SPRITES.size() > 0:
		sprite_node.texture = ROCK_SPRITES[randi() % ROCK_SPRITES.size()]

	# ✅ Fade in
	sprite_node.modulate.a = 0.0
	var tween = create_tween()
	tween.tween_property(sprite_node, "modulate:a", 1.0, fade_in_time)

	# ✅ Connect collision detection
	if not is_connected("area_entered", Callable(self, "_on_area_entered")):
		connect("area_entered", Callable(self, "_on_area_entered"))

func _on_area_entered(area):
	if fading_out:
		return

	if area.is_in_group("Player"):
		if hunger_bar and hunger_bar.has_method("add_hunger"):
			hunger_bar.call("add_hunger", hunger_fill_amount)

		# 🎧 Play a random rock collision sound
		audio_player.stream = ROCK_SOUNDS[randi() % ROCK_SOUNDS.size()]
		audio_player.play()

		# 💥 Shake the camera
		if camera and camera.has_method("shake"):
			camera.shake(shake_intensity, shake_duration)

		start_fade_out()

func start_fade_out():
	if fading_out or not sprite_node:
		return
	fading_out = true

	var tween = create_tween()
	tween.tween_property(sprite_node, "modulate:a", 0.0, fade_out_time)
	tween.connect("finished", Callable(self, "_on_fade_complete"))

func _on_fade_complete():
	if audio_player.playing:
		await audio_player.finished
	queue_free()
