extends Node2D

@onready var player: Player 
@onready var player_spawn: Marker2D = $PlayerSpawn
@onready var camera : Camera2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	player.position = player_spawn.global_position
	var camera = player.get_node("Camera")
	
	camera.zoom = Vector2(1.2, 1.2)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
