extends Area2D
class_name HurtboxComponent

enum EntityClass {
	ENEMY,
	PLAYER,
	ALLY
}

@export var entityClass: EntityClass

#ainda mais generico
#@export_flags("PLAYER MELEE","PLAYER BULLET", "ENEMY MELEE", "ENEMY BULLET", "TRAP") var damageFrom

@export var healthComponent: HealthComponent

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func can_accept_collision() -> bool:
	return healthComponent.has_health_remaining() if healthComponent else true

func _on_area_entered(area: Area2D) -> void:
	pass
