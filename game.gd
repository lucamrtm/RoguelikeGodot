extends Node2D

@onready var level = $Level1
@onready var camera = $Camera
@onready var player = $Player
@onready var hearts_container = $CanvasLayer/heartsContainer
@onready var weapon_manager = $WeaponManager
@onready var enemy_spawner = $EnemySpawner

@export var rooms: Array[PackedScene]
var nextRoom = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	remove_child(camera)
	player.add_child(camera)
	camera.zoom = Vector2(0.9, 0.9)  # teste (aproxima)#camera.zoom = Vector2(1.2, 1.2)  # Aumenta o zoom (aproxima)
	hearts_container.player_health = player.health
	player.health.healthChanged.connect(hearts_container.updateHearts)
	weapon_manager.player = player
	weapon_manager.equip_starting_weapon()
	enemy_spawner.room_cleared.connect(room_cleared)
	level.level_exit_entered.connect(next_level)
	camera.limit_top = level.upper_left_limit.global_position.y
	camera.limit_left = level.upper_left_limit.global_position.x
	camera.limit_bottom = level.bottom_right_limit.global_position.y
	camera.limit_right = level.bottom_right_limit.global_position.x


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func room_cleared() -> void:
	level.enable_exit()


func next_level() -> void:
	level.queue_free()
	level = rooms[nextRoom].instantiate()
	add_child(level)
	level.level_exit_entered.connect(next_level)
	player.position = level.spawnpoint.position
	camera.position = player.position
	if nextRoom == 0:
		enemy_spawner.trigger_cleared = false
		enemy_spawner.maxEnemies = 2
		enemy_spawner.currentEnemies = 0
		enemy_spawner.timer.start()
	nextRoom += 1
