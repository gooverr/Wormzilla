extends Camera2D

@export var shake_intensity: float = 5.0
@export var shake_duration: float = 0.2

var shake_timer: float = 0.0
var original_offset := Vector2.ZERO

func _ready():
	original_offset = offset

func _process(delta):
	if shake_timer > 0:
		shake_timer -= delta
		offset = original_offset + Vector2(
			randf_range(-shake_intensity, shake_intensity),
			randf_range(-shake_intensity, shake_intensity)
		)
	else:
		offset = original_offset

func shake(intensity: float = 5.0, duration: float = 0.2):
	shake_intensity = intensity
	shake_duration = duration
	shake_timer = duration
