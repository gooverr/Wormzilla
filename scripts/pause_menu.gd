extends CanvasLayer

var is_paused = false

func _ready():
	visible = false
	process_mode = Node.PROCESS_MODE_ALWAYS  # ✅ Menu works while paused

func _input(event):
	if event.is_action_pressed("ui_cancel"):  # Usually ESC
		toggle_pause()

func toggle_pause():
	is_paused = !is_paused
	visible = is_paused
	get_tree().paused = is_paused

func _on_resume_button_pressed():
	toggle_pause()

func _on_restart_button_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_quit_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/title_screen.tscn")  # <-- Update path
