extends Node2D
const LEVEL_1 = preload("res://Map/level_1.tscn")
@onready var level = LEVEL_1
@onready var camera = $Camera
@onready var player = $Player
@onready var hearts_container = $CanvasLayer/heartsContainer
@onready var weapon_manager = $WeaponManager
@onready var enemy_spawner = $Level1/EnemySpawner

@onready var current_level



const LEVEL_2 = preload("res://Map/level_2.tscn")

@export var rooms: Array[PackedScene]
var nextRoom = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	remove_child(camera)
	player.add_child(camera)
	camera.zoom = Vector2(1.2, 1.2)  # Aumenta o zoom (aproxima)
	hearts_container.player_health = player.health
	player.health.healthChanged.connect(hearts_container.updateHearts)
	weapon_manager.player = player
	weapon_manager.equip_starting_weapon()
	enemy_spawner.room_cleared.connect(room_cleared)
	current_level = level.instantiate()
	current_level.level_exit_entered.connect(next_level)
	
	if current_level.has_node("UpperLeftLimit") and current_level.has_node("BottomRightLimit"):
		var upper_left_limit = current_level.get_node("UpperLeftLimit")
		var bottom_right_limit = current_level.get_node("BottomRightLimit")
		camera.limit_top = upper_left_limit.global_position.y
		camera.limit_left = upper_left_limit.global_position.x
		camera.limit_bottom = bottom_right_limit.global_position.y
		camera.limit_right = bottom_right_limit.global_position.x
	else:
		print("Limites do nível não encontrados!")
	

func get_level():
	return current_level

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func room_cleared() -> void:
	level.enable_exit()



func next_level() -> void:
	level.queue_free()
	level = rooms[nextRoom].instantiate()
	current_level = rooms[nextRoom]
	add_child(level)
	level.level_exit_entered.connect(next_level)
	player.position = level.spawnpoint.position
	camera.position = player.position
	nextRoom += 1
