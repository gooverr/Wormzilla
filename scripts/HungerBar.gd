extends TextureProgressBar

@export var drain_rate: float = 4.0
var is_draining: bool = true

var real_value: float

func _ready():
	step = 0.0  # for smooth fractional steps
	real_value = value

func _process(delta):
	if is_draining:
		real_value -= drain_rate * delta
		real_value = clamp(real_value, min_value, max_value)
		value = real_value

		if real_value <= min_value:
			_on_bar_empty()

func _on_bar_empty():
	print("Bar is empty!")
	# Don't disable draining so the bar can be refilled

func add_hunger(amount: float):
	real_value = clamp(real_value + amount, min_value, max_value)
	value = real_value
	is_draining = true
	print("Hunger added:", amount, "Current value:", value)
