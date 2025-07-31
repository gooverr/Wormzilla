extends Area2D

@export var hunger_fill_amount: float = 10.0
var player

func _process(delta):
	# Move away from the player slowly
	if player:
		var direction = (global_position - player.global_position).normalized()
		global_position += direction * 50 * delta

func _on_Food_body_entered(body):
	if body.is_in_group("Player"):
		# Increase hunger bar here (we’ll handle later)
		queue_free()  # remove food
