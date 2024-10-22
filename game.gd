extends Node2D

@onready var HEARTS_CONTAINER = $CanvasLayer/heartsContainer
@onready var player: Player = $TileMap/Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	HEARTS_CONTAINER.player_health = player.health
	player.health.healthChanged.connect(HEARTS_CONTAINER.updateHearts)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
