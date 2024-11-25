extends Control

@onready var scoreLabel: Label = $Score
@onready var enemy_spawner: Node2D = get_node("/root/Game/EnemySpawner")

var score

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	score = enemy_spawner.get_max_enemies()

	scoreLabel.text = "Inimigos restantes: %d" % score


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func updateScore():
	score -= 1
	scoreLabel.text = "Inimigos restantes: %d" % score
	
func isZero():
	return true if score == 0 else false
