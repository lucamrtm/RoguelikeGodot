extends Area2D
class_name HurtboxComponent

signal hit_by_hitbox(hitbox: Node)  # Agora pode aceitar qualquer nó (ex.: enemy_bullet)
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

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

func disable_collision():
	collision_shape_2d.disabled = true
	
func enable_collision():
	collision_shape_2d.disabled = false

func _on_area_entered(hitbox: HitboxComponent) -> void:
	if hitbox:
		hit_by_hitbox.emit(hitbox)
		
