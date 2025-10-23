extends Node2D

@export var rock_scene: PackedScene
@export var min_spawn_distance: float = 1500.0     # Minimum distance from player (offscreen start)
@export var max_spawn_distance: float = 2400.0    # Maximum distance from player
@export var min_spacing: float = 650.0            # Minimum spacing between rocks
@export var max_rocks: int = 25                   # Maximum rocks allowed at once
@export var despawn_distance: float = 3400.0      # Distance from player before despawning
@export var spawn_interval: float = 2.0

var player: Node
var rocks: Array = []
var spawned_positions: Array = []


func _ready():
	player = get_tree().get_first_node_in_group("Player")
	if not player:
		push_warning("⚠️ Player not found! Add Player to 'Player' group.")
		return
	if not rock_scene:
		push_warning("⚠️ Rock scene not assigned!")
		return

	var timer = Timer.new()
	timer.wait_time = spawn_interval
	timer.autostart = true
	timer.connect("timeout", Callable(self, "_on_timer_timeout"))
	add_child(timer)


func _on_timer_timeout():
	cleanup_distant_rocks()

	# Only spawn if we haven't reached the maximum rock count
	if rocks.size() < max_rocks:
		spawn_rock()


func spawn_rock():
	if not rock_scene or not player:
		return

	var pos: Vector2
	var valid_pos := false
	var attempts := 0

	while not valid_pos and attempts < 15:
		attempts += 1

		var angle = randf() * TAU
		var distance = randf_range(min_spawn_distance, max_spawn_distance)
		pos = player.global_position + Vector2(cos(angle), sin(angle)) * distance

		valid_pos = true
		for other_pos in spawned_positions:
			if pos.distance_to(other_pos) < min_spacing:
				valid_pos = false
				break

	if not valid_pos:
		return

	var rock = rock_scene.instantiate()
	add_child(rock)
	rock.global_position = pos

	rocks.append(rock)
	spawned_positions.append(pos)

	# Keep arrays trimmed
	if spawned_positions.size() > 100:
		spawned_positions.pop_front()


func cleanup_distant_rocks():
	if not player:
		return

	for rock in rocks:
		if not is_instance_valid(rock):
			continue

		if rock.global_position.distance_to(player.global_position) > despawn_distance:
			rock.queue_free()

	# Remove freed or invalid references
	rocks = rocks.filter(func(r): return is_instance_valid(r))
