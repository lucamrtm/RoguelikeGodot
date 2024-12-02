extends Control

@onready var scoreLabel: Label = $Score
@onready var enemy_spawner : Node2D


var score

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	enemy_spawner = get_tree().get_first_node_in_group("EnemySpawner")
	
	score = enemy_spawner.get_max_enemies()

	scoreLabel.text = "Inimigos restantes: %d" % score


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func updateScore():
	score -= 1
	scoreLabel.text = "Inimigos restantes: %d" % score
	if score == 0:
		# Notifica o Game que a sala foi limpa
		var game = get_node("/root/Game")  # Ajuste o caminho para o nó Game
		print("acabou a sala")
	
func isZero():
	return true if score == 0 else false
