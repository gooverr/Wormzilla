extends CanvasLayer

@onready var final_score_label: Label = $Label
@onready var try_again_button: Button = $TryAgainButton
@onready var death_sound: AudioStreamPlayer = $AudioStreamPlayer  # Add this line!

func _ready():
	visible = false
	if try_again_button:
		try_again_button.connect("pressed", Callable(self, "_on_try_again_pressed"))
	else:
		push_warning("⚠ TryAgainButton not found!")

# Called when the player dies
func show_death_screen():
	print("📜 show_death_screen() called!")

	var score_manager = get_tree().get_first_node_in_group("Score")
	if score_manager:
		print("✅ Score manager found! Final score =", score_manager.score)
		final_score_label.text = "Final Score: " + str(score_manager.score)
	else:
		print("❌ Score manager not found. Defaulting to 0.")
		final_score_label.text = "Final Score: 0"

	# ✅ Make visible and pause the game
	visible = true
	get_tree().paused = true  
	print("⏸ Game paused and death screen visible.")

	# ✅ Play death sound
	if death_sound:
		death_sound.play()
	else:
		push_warning("⚠ AudioStreamPlayer not found for death sound!")

func _on_try_again_pressed():
	print("🔄 Restart button clicked!")
	get_tree().paused = false
	get_tree().reload_current_scene()
