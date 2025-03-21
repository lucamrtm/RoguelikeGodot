extends Node2D

signal room_cleared

@export var spawns: Array[Spawn_info] = []

@onready var control : Control = $"../CanvasLayer2/Control"
@onready var map : Node = get_parent().get_node("Map_2")

var top_left : Vector2
var top_right : Vector2
var bottom_left : Vector2
var bottom_right : Vector2

var top_left_marker : Marker2D
var bottom_right_marker : Marker2D

@onready var player = get_tree().get_first_node_in_group("player")
@onready var timer: Timer = $Timer
const BOSS = preload("res://Enemies/Boss.tscn")
const ATTCKSPEEDBOOST = preload("res://Weapons/attckspeedboost.tscn")
var boss_spawned = false  # Variável para controlar se o chefe já foi spawnado
var trigger_cleared = false

@export var maxEnemies : int
var currentEnemies = 0

var time = 0

	


func _ready() -> void:
	print("chegou")
	if map:
		top_left_marker = get_parent().get_node("SpawnerUpperLeftLimit")  # Caminho relativo dentro de Map_2
		bottom_right_marker = get_parent().get_node("SpawnerBottomRightLimit")
		
		if top_left_marker and bottom_right_marker:
			print("Marcadores encontrados!")
			print("Top Left:", top_left_marker.global_position)
			print("Bottom Right:", bottom_right_marker.global_position)
		else:
			print("Um ou ambos os marcadores não foram encontrados dentro de Level_2!")
	else:
		print("Map_2 não foi encontrado!")
		
	top_left = top_left_marker.position
	bottom_right = bottom_right_marker.position
	top_right = Vector2(bottom_right.x, top_left.y)
	bottom_left = Vector2(top_left.x, bottom_right.y)

func _process(delta: float) -> void:
	#if control.isZero():
		#queue_free()
		#timer.stop()
	if currentEnemies == maxEnemies:
		timer.stop()
	if control.isZero() and not trigger_cleared: ### TA DANDO NULL PQQQQQQQQQ
		spawn_attack_speed_boost()
		trigger_cleared = true
		room_cleared.emit()


func get_max_enemies():
	return maxEnemies
	

func spawn_attack_speed_boost():
	var boost_spawn = ATTCKSPEEDBOOST.instantiate()
	add_child(boost_spawn)


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
					currentEnemies+=1
					enemy_spawn.global_position = get_random_position()
					add_child(enemy_spawn)
					counter += 1

func get_random_position() -> Vector2:
	# Escolhe aleatoriamente qual lado será usado para o spawn
	var pos_side = ["up", "down", "right", "left"].pick_random()
	var spawn_pos1 = Vector2.ZERO
	var spawn_pos2 = Vector2.ZERO

	# Define os limites baseados nos marcadores
	match pos_side:
		"up":
			spawn_pos1 = top_left
			spawn_pos2 = top_right
		"down":
			spawn_pos1 = bottom_left
			spawn_pos2 = bottom_right
		"right":
			spawn_pos1 = top_right
			spawn_pos2 = bottom_right
		"left":
			spawn_pos1 = top_left
			spawn_pos2 = bottom_left

	# Gera uma posição aleatória entre os dois pontos definidos
	var x_spawn = randf_range(spawn_pos1.x, spawn_pos2.x)
	var y_spawn = randf_range(spawn_pos1.y, spawn_pos2.y)

	# Retorna a posição gerada
	return Vector2(x_spawn, y_spawn)

	
