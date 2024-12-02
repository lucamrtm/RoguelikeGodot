extends Node2D

signal room_cleared

@export var spawns: Array[Spawn_info] = []
@onready var level: Node2D

@onready var map : Node 

var top_left : Vector2
var top_right : Vector2
var bottom_left : Vector2
var bottom_right : Vector2

@onready var currentSpawn = 0

var top_left_marker : Marker2D
var bottom_right_marker : Marker2D
var top_right_marker : Marker2D
var bottom_left_marker: Marker2D
@onready var boost_spawn_pos: Marker2D = $"../BoostSpawn"

const MAGE = preload("res://Enemies/Mage/Mage.tscn")
@onready var player = get_tree().get_first_node_in_group("player")
@onready var timer: Timer = $Timer
const BOSS = preload("res://Enemies/Boss.tscn")
const ATTCKSPEEDBOOST = preload("res://Weapons/attckspeedboost.tscn")
var boss_spawned = false  # Variável para controlar se o chefe já foi spawnado
var trigger_cleared = false

@onready var boost_spawned = false

var control: GameUI

@export var maxEnemies : int
var currentEnemies = 0

var time = 0

func _ready() -> void:
	level = get_tree().get_first_node_in_group("Level")
	control = level.get_node("Map/CanvasLayer/Control")
	print(control)
	
	var map = level.get_node("Map")
	if map:
		top_left_marker =  level.get_node("Map/SpawnerUpperLeftLimit")  # Caminho relativo dentro de Map_1
		bottom_right_marker = level.get_node("Map/SpawnerBottomRightLimit")
		top_right_marker =  level.get_node("Map/SpawnerUpperRightLimit") 
		bottom_left_marker = level.get_node("Map/SpawnerBottomLeftLimit")
		
		if top_left_marker and bottom_right_marker:
			print("Marcadores encontrados!")
			print("Top Left:", top_left_marker.global_position)
			print("Bottom Right:", bottom_right_marker.global_position)
		else:
			print("Um ou ambos os marcadores não foram encontrados dentro de Level")
	else:
		print("Map não foi encontrado!")
		
	#top_left = top_left_marker.global_position
	#bottom_right = bottom_right_marker.global_position
	#top_right = top_right_marker.global_position
	#bottom_left = bottom_left_marker.global_position

func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
		#if control.isZero():
		#queue_free()
		#timer.stop()
		
	level = get_tree().get_first_node_in_group("Level")
	control = level.get_node("Map/CanvasLayer/Control")
	var map = level.get_node("Map")
	if map:
		top_left_marker =  level.get_node("Map/SpawnerUpperLeftLimit") 
		bottom_right_marker = level.get_node("Map/SpawnerBottomRightLimit")
		top_right_marker =  level.get_node("Map/SpawnerUpperRightLimit") 
		bottom_left_marker = level.get_node("Map/SpawnerBottomLeftLimit")
	
	
	#w
	
	if currentEnemies == maxEnemies:
		timer.stop()
	
	if control.isZero() and not boost_spawned:
		
		spawn_attack_speed_boost()

func get_max_enemies():
	return maxEnemies
	

func spawn_attack_speed_boost():
	boost_spawned = true
	print("boost spawnado")
	var boost_spawn = ATTCKSPEEDBOOST.instantiate()
	get_parent().add_child(boost_spawn)
	boost_spawn.position = boost_spawn_pos.position


func reset_spawner():
	# Reseta as variáveis relacionadas ao controle de spawn
	spawns[0] = null
	
	var spawn_1 = Spawn_info.new()
	spawn_1.time_start = 0
	spawn_1.time_end = 60
	spawn_1.enemy = MAGE  # Caminho para a cena do inimigo
	spawn_1.enemy_num = 1
	spawn_1.enemy_spawn_delay = 2
	
	spawns = [spawn_1]
	
	
	
	currentSpawn +=1
	currentEnemies = 0
	time = 0
	boost_spawned = false
	boss_spawned = false

	# Reinicia os contadores de cada spawn

	# Reinicia o timer
	if timer:
		timer.start()

	print("Spawner resetado!")


func spawn_boss():
	boss_spawned = true  # Define como verdadeiro para impedir spawn duplicado
	var boss_spawn = BOSS.instantiate()
	add_child(boss_spawn)


func _on_timer_timeout() -> void:
	time+= 1
	var enemy_spawns = spawns
	for i in enemy_spawns:
		if time >= i.time_start and time <= i.time_end:
			if i.spawn_delay_counter < i.enemy_spawn_delay:
				i.spawn_delay_counter += 1
			else:
				i.spawn_delay_counter = 0
				var new_enemy = load(str(i.enemy.resource_path))
				var counter = 0
				while counter < i.enemy_num:
					var enemy_spawn = new_enemy.instantiate()
					enemy_spawn.control = control
					currentEnemies+=1
					enemy_spawn.position = get_random_position()
					add_child(enemy_spawn)
					counter += 1

func get_random_position() -> Vector2:
	var markers = get_tree().get_nodes_in_group("spawner_point")
	for i in markers:
		print(i)
	var random_marker: Marker2D = markers.pick_random()
	return random_marker.global_position
