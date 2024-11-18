extends Area2D
class_name HitboxComponent

@export var hitStats: HitStats

@export var damageTo: Array[String]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var ownerGroups = owner.get_groups()
	for groupName in ownerGroups:
		add_to_group(groupName)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
