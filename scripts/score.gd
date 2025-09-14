extends CanvasLayer

# Declare the score variable
var score : int = 0

# Reference to the Label to display the score
@onready var score_label = $Label

func _ready():
	# Update the label with the initial score
	update_score()

# Function to update the score and update the label text
func update_score():
	score_label.text = "Score: " + str(score)
	print(score,': score')

# Function to increase the score (you can call this when certain actions occur)
func increase_score(amount: int):
	score += amount + 9
	update_score()  # Update the label whenever the score changes
