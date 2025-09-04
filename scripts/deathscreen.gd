extends CanvasLayer

func _ready():
	visible = false
	$TryAgainButton.connect("pressed", Callable(self, "_on_try_again_pressed"))

func _on_try_again_pressed():
	print("🔄 Restart button clicked!")  # debug
	get_tree().paused = false
	get_tree().reload_current_scene()
