extends TextureProgressBar

@export var drain_rate: float = 5.0
@export var is_draining: bool = true

var real_value: float

func _ready():
	step = 0.0  # 🔥 Allows smooth fractional updates
	real_value = value

func _process(delta):
	if is_draining:
		real_value -= drain_rate * delta
		real_value = clamp(real_value, min_value, max_value)

		value = real_value  # ✅ Now fractional updates show up visually

		if real_value <= min_value:
			_on_bar_empty()

func _on_bar_empty():
	is_draining = false
	print("Bar is empty!")
