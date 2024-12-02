extends Area2D

const FILE_BEGIN = "res://Levels/Scenes/Level_"

var level = 1
@onready var enemy_spawner: Node2D = $"../EnemySpawner"

const LEVEL_2 = preload("res://Levels/Scenes/Level_2.tscn")
const LEVEL_3 = preload("res://Levels/Scenes/Level_3.tscn")
const MAGE = preload("res://Enemies/Mage/Mage.tscn")

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		level += 1
		var current_scene = get_tree().get_first_node_in_group("Level")
		
		
		var next_level_path = FILE_BEGIN + str(level) + ".tscn"
		print(current_scene)
		print(next_level_path)
		var next_level_scene = load(next_level_path)
		
		get_tree().get_first_node_in_group("Level").get_parent().add_child(next_level_scene.instantiate())

		
		if level < 3:
			enemy_spawner.reset_spawner()
		current_scene.free()
		
	
