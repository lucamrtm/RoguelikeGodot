extends Node2D

@onready var camera = $Camera
@onready var player = $TileMap/Player
@onready var hearts_container = $CanvasLayer/heartsContainer
@onready var weapon_manager = $WeaponManager

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	remove_child(camera)
	player.add_child(camera)
	hearts_container.player_health = player.health
	player.health.healthChanged.connect(hearts_container.updateHearts)
	weapon_manager.player = player
	weapon_manager.equip_starting_weapon()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
