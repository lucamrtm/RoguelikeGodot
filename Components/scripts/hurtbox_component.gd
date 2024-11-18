extends Area2D
class_name HurtboxComponent

signal hit_by_hitbox(hitbox: HitboxComponent)

@export var canGetHit: bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var ownerGroups = owner.get_groups()
	for groupName in ownerGroups:
		add_to_group(groupName)
	connect("area_entered", _on_area_entered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func can_accept_collision() -> bool:
	return canGetHit


func _on_area_entered(hitbox: HitboxComponent) -> void:
	if hitbox:
		hit_by_hitbox.emit(hitbox)
