extends Node2D
var sceneLimit : Marker2D
@onready var camera: Camera2D = $Player/Camera

var currentScene = null
@onready var level_switcher = get_node("NextLevel")
@onready var player = $Player
@onready var boost_spawn: Marker2D = $BoostSpawn

@onready var hearts_container = $CanvasLayer/heartsContainer
@onready var weapon_manager = $WeaponManager

@onready var map : Node 
@onready var level: Node2D



var upper_left_limit : Marker2D
var bottom_right_limit : Marker2D

func _ready() -> void:
	
	level = get_tree().get_first_node_in_group("Level")
	
	
	hearts_container.player_health = player.health
	player.health.healthChanged.connect(hearts_container.updateHearts)
	weapon_manager.player = player
	weapon_manager.equip_starting_weapon()
	
	
	camera.zoom = Vector2(1.5,1.5)
	
	upper_left_limit =  level.get_node("Map/UpperLeftLimit")  # Caminho relativo dentro de Map_1
	bottom_right_limit = level.get_node("Map/BottomRightLimit")
	camera.limit_top = upper_left_limit.global_position.y
	camera.limit_left = upper_left_limit.global_position.x
	camera.limit_bottom = bottom_right_limit.global_position.y
	camera.limit_right = bottom_right_limit.global_position.x
	
	
	
			
func _physics_process(delta: float) -> void:
	level = get_tree().get_first_node_in_group("Level")
	if level.has_node("NextLevelPoint"):
		level_switcher.position = (level.get_node("NextLevelPoint")).position
	
	upper_left_limit =  level.get_node("Map/UpperLeftLimit")  # Caminho relativo dentro de Map_1
	bottom_right_limit = level.get_node("Map/BottomRightLimit")
	camera.limit_top = upper_left_limit.global_position.y
	camera.limit_left = upper_left_limit.global_position.x
	camera.limit_bottom = bottom_right_limit.global_position.y
	camera.limit_right = bottom_right_limit.global_position.x
		

func process():
	pass
