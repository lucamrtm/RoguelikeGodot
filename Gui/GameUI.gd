extends Control

@onready var scoreLabel: Label = $Score


var score = 5


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	scoreLabel.text = "Inimigos restantes: %d" % score


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func updateScore():
	score -= 1
	scoreLabel.text = "Inimigos restantes: %d" % score
	
func isZero():
	return true if score == 0 else false
