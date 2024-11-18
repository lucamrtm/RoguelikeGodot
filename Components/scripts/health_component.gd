extends Node2D
class_name HealthComponent

signal healthChanged(change)
signal maxHealthChanged(change)
signal died

@export var maxHealth: int:
	set(value):
		maxHealth = value
		if currentHealth > maxHealth:
			currentHealth = maxHealth

var currentHealth: int = maxHealth:
	set(value):
		var previousHealth = currentHealth
		currentHealth = clamp(value, 0, maxHealth)
		if previousHealth != currentHealth:
			healthChanged.emit(previousHealth-currentHealth)
		if currentHealth <= 0:
			died.emit()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	call_deferred("initialize_health")

func has_health_remaining() -> bool:
	return currentHealth >= 0

func damage(damage: int) -> void:
	currentHealth -= damage

func heal(heal: int) -> void:
	damage(-heal)
	
func set_max_health(health: int) -> void:
	maxHealth = health
	
func initialize_health() -> void:
	currentHealth = maxHealth
