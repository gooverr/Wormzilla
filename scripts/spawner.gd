extends Node2D

@export var food_scene: PackedScene
@export var spawn_radius: float = 500.0
@export var spawn_interval: float = 1.1

var player
var hunger_bar

func _ready():
	player = get_tree().get_first_node_in_group("Player")
	hunger_bar = get_tree().get_first_node_in_group("HungerBar")

	if not player:
		push_warning("Player node not found! Add Player to 'Player' group.")
		return
	if not hunger_bar:
		push_warning("HungerBar not found! Add it to the 'HungerBar' group.")
		return
	if not food_scene:
		push_warning("⚠️ Food scene not assigned in Spawner: %s" % name)
		return

	var timer = Timer.new()
	timer.wait_time = spawn_interval
	timer.autostart = true
	timer.connect("timeout", Callable(self, "spawn_food"))
	add_child(timer)

func spawn_food():
	if food_scene == null:
		return
	
	var food = food_scene.instantiate()
	add_child(food)

	var angle = randf() * TAU
	var offset = Vector2(cos(angle), sin(angle)) * spawn_radius
	food.global_position = player.global_position + offset

	# ✅ Don’t type this – prevents assignment errors
	food.player = player
