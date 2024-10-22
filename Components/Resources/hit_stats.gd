extends Resource
class_name HitStats

enum DamageType {
	MELEE,
	DISTANCE
}

@export var damage: int
@export var damageType: DamageType
@export var knockback: float
@export var cooldown: float

@export var can_damage: bool = true
