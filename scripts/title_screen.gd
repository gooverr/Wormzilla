extends CanvasLayer

@export var game_scene_path: String = "res://scenes/game.tscn"

func _ready():
	visible = true
	#get_tree().paused = true  # Pause the game while title is showing

func _on_start_button_pressed():
	print("Start button pressed!")
	get_tree().paused = false

	var result = get_tree().change_scene_to_file(game_scene_path)
	if result != OK:
		push_error("❌ Failed to load scene! Error code: %d" % result)
	else:
		print("✅ Scene loaded successfully!")


func _on_quit_button_pressed():
	get_tree().quit()
