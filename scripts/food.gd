extends Area2D

@export var hunger_fill_amount: float = 15.0

var player: Node
var hunger_bar

# Paths to your texture files (relative to the "res://" project root)
const FOOD_SPRITES = [
	preload("res://Textures/bug1.png"),
	preload("res://Textures/bug2.png")
]

func _ready():
	print("✅ Food ready at:", global_position)

	# Connect once
	if not is_connected("area_entered", Callable(self, "_on_area_entered")):
		connect("area_entered", Callable(self, "_on_area_entered"))

	# Find player and hunger bar
	player = get_tree().get_first_node_in_group("Player")
	hunger_bar = get_tree().get_first_node_in_group("HungerBar")  # Should be the TextureProgressBar

	# Randomly assign a sprite texture
	var sprite_node = get_node("Sprite2D")
	if sprite_node and FOOD_SPRITES.size() > 0:
		var random_texture = FOOD_SPRITES[randi() % FOOD_SPRITES.size()]
		sprite_node.texture = random_texture
	else:
		push_warning("❌ Could not assign food sprite — missing Sprite2D or textures.")

func _process(delta):
	# Move away from player
	if player:
		var direction = (global_position - player.global_position).normalized()
		global_position += direction * 50 * delta

func _on_area_entered(area):
	print("🚨 AREA TOUCHED FOOD:", area.name)

	if area.is_in_group("Player"):
		if hunger_bar and hunger_bar.has_method("add_hunger"):
			hunger_bar.call("add_hunger", hunger_fill_amount)
			print("🍏 Hunger added:", hunger_fill_amount)
		else:
			print("⚠️ HungerBar not found or missing add_hunger()")

		queue_free()
