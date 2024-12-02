extends Area2D

const FILE_BEGIN = "res://Levels/Scenes/Level_"

var level = 1

const LEVEL_2 = preload("res://Levels/Scenes/Level_2.tscn")

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		level += 1
		var current_scene = get_tree().get_first_node_in_group("Level")
		
		
		var next_level_path = FILE_BEGIN + str(level) + ".tscn"
		print(current_scene)
		print(next_level_path)
		
		get_tree().get_first_node_in_group("Level").get_parent().add_child(LEVEL_2.instantiate())
		current_scene.free()
		
	
