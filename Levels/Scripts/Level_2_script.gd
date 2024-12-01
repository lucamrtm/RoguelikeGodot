extends Node2D
const LEVEL_2 = preload("res://Map/map_2.tscn")

@onready var map : Node = get_node("Map_2")
@onready var camera = $Player/Camera
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
	camera.position = player.position
	camera.zoom = Vector2(1.2, 1.2)  # Aumenta o zoom (aproxima)
	hearts_container.player_health = player.health
	player.health.healthChanged.connect(hearts_container.updateHearts)
	weapon_manager.player = player
	weapon_manager.equip_starting_weapon()
	
	
	var upper_left_limit = map.get_node("UpperLeftLimit")
	var bottom_right_limit = map.get_node("BottomRightLimit")
	camera.limit_top = upper_left_limit.global_position.y
	camera.limit_left = upper_left_limit.global_position.x
	camera.limit_bottom = bottom_right_limit.global_position.y
	camera.limit_right = bottom_right_limit.global_position.x
	

func get_map():
	return map

func _physics_process(delta: float) -> void:
	camera.position = player.position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
