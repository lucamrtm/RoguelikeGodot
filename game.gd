extends Node2D
var sceneLimit : Marker2D
@onready var camera: Camera2D = $Player/Camera

var currentScene = null
@onready var level_switcher = get_node("NextLevel")
@onready var player = $Player

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
	
	
	camera.zoom = Vector2(2.5,2.5)
	
	upper_left_limit =  level.get_node("Map/UpperLeftLimit")  # Caminho relativo dentro de Map_1
	bottom_right_limit = level.get_node("Map/BottomRightLimit")
	camera.limit_top = upper_left_limit.global_position.y
	camera.limit_left = upper_left_limit.global_position.x
	camera.limit_bottom = bottom_right_limit.global_position.y
	camera.limit_right = bottom_right_limit.global_position.x
	
	
	
			
func _physics_process(delta: float) -> void:
	level = get_tree().get_first_node_in_group("Level")
	
	
	upper_left_limit =  level.get_node("Map/UpperLeftLimit")  # Caminho relativo dentro de Map_1
	bottom_right_limit = level.get_node("Map/BottomRightLimit")
	camera.limit_top = upper_left_limit.global_position.y
	camera.limit_left = upper_left_limit.global_position.x
	camera.limit_bottom = bottom_right_limit.global_position.y
	camera.limit_right = bottom_right_limit.global_position.x
		

func process():
	pass


func _load_next_level(next_level_path: String) -> void:
	print("Carregando próximo nível:", next_level_path)
	
	# Verifica se o próximo nível existe
	if FileAccess.file_exists(next_level_path):
		# Troca para o próximo nível
		get_tree().change_scene_to_file(next_level_path)
	else:
		print("Erro: Arquivo do próximo nível não encontrado:", next_level_path)



func goto_scene(path: String):
	print("Total children: "+str(get_child_count()))
	var world := get_child(1)
	world.free()
	var res := ResourceLoader.load(path)
	currentScene = res.instance()
	sceneLimit = null
	get_tree().get_root().add_child(currentScene)
		
