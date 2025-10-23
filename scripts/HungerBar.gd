extends TextureProgressBar

@export var drain_rate: float = 6.5
var is_draining: bool = true
var real_value: float

func _ready():
	step = 0.0
	real_value = value

func _process(delta):
	if is_draining:
		# Drain hunger every frame
		real_value -= drain_rate * delta
		real_value = clamp(real_value, min_value, max_value)
		value = real_value

		# When hunger runs out
		if real_value <= min_value:
			_on_bar_empty()

func _on_bar_empty():
	is_draining = false
	print("💀 Hunger empty — Game Over!")

	var death_screen = get_tree().get_first_node_in_group("DeathScreen")
	if death_screen:
		# Call the death screen's show function
		if death_screen.has_method("show_death_screen"):
			death_screen.show_death_screen()
		else:
			print("⚠ DeathScreen found but missing method 'show_death_screen'")
	else:
		push_warning("⚠ No DeathScreen found in group 'DeathScreen'")

func add_hunger(amount: float):
	real_value = clamp(real_value + amount, min_value, max_value)
	value = real_value
	is_draining = true
	print("🍏 Hunger added:", amount, "Current value:", value)
