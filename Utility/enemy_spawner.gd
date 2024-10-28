extends Node2D


@export var spawns : Array[Spawn_info] = []
@onready var control: Control = get_node("/root/Game/CanvasLayer/Control")
@onready var player = get_tree().get_first_node_in_group("player")
@onready var timer: Timer = $Timer
const BOSS = preload("res://Enemies/Boss.tscn")
var boss_spawned = false  # Variável para controlar se o chefe já foi spawnado

@export var maxEnemies : int
var currentEnemies = 0

var time =0

func _process(delta: float) -> void:
	#if control.isZero():
		#queue_free()
		#timer.stop()
	if currentEnemies == maxEnemies:
		timer.stop()
	if control.isZero()and not boss_spawned:
		spawn_boss()


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

func get_random_position():
	var vpr = get_viewport_rect().size
	var top_left = Vector2(-vpr.x / 4,-vpr.y / 4)
	var top_right = Vector2(vpr.x / 4, -vpr.y / 4)
	var bottom_left = Vector2(-vpr.x / 4, vpr.y / 4)
	var bottom_right = Vector2(vpr.x / 4, vpr.y / 4)
	
	var pos_side = ["up", "down", "right", "left"].pick_random()
	var spawn_pos1 = Vector2.ZERO
	var spawn_pos2 = Vector2.ZERO
	
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
		
	var x_spawn = randf_range(spawn_pos1.x, spawn_pos2.x)
	var y_spawn = randf_range(spawn_pos1.y, spawn_pos2.y)
	
	return Vector2(x_spawn, y_spawn)
	
