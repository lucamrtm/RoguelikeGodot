extends Control

var scoreLabel: Label

var score: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func updateScore(scoreChange: int):
	score += scoreChange
	scoreLabel.text = "Inimigos restantes: %d" % score
	if score == 0:
		# Notifica o Game que a sala foi limpa
		var game = get_node("/root/Game")  # Ajuste o caminho para o nó Game
		print("acabou a sala")
	
func isZero():
	return score == 0
