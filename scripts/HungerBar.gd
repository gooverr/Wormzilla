extends TextureProgressBar

@export var drain_rate: float = 6.0
var is_draining: bool = true
var real_value: float

@onready var death_screen = get_tree().get_first_node_in_group("DeathScreen")

func _ready():
	step = 0.0
	real_value = value

func _process(delta):
	if is_draining:
		real_value -= drain_rate * delta
		real_value = clamp(real_value, min_value, max_value)
		value = real_value

		if real_value <= min_value:
			_on_bar_empty()

func _on_bar_empty():
	is_draining = false
	print("💀 Hunger empty — Game Over!")
	if death_screen:
		death_screen.visible = true
		get_tree().paused = true
	else:
		push_warning("⚠ No DeathScreen found in group 'DeathScreen'")

func add_hunger(amount: float):
	real_value = clamp(real_value + amount, min_value, max_value)
	value = real_value
	is_draining = true
	print("🍏 Hunger added:", amount, "Current value:", value)
