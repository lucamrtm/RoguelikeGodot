extends Node2D
class_name DashComponent

@export var dash_speed: float
@export var dash_time: float
@export var cooldown_time: float

var dash_direction: Vector2

var dashing = false
var can_dash = true

@onready var dash_timer = $DashTimer
@onready var cooldown_timer = $DashCooldown

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	dash_timer.wait_time = dash_time
	cooldown_timer.wait_time = cooldown_time
	
	dash_timer.timeout.connect(_on_dash_timer_timeout)
	cooldown_timer.timeout.connect(_on_dash_cooldown_timeout)


func is_dashing() -> bool:
	return dashing


func do_dash(direction: Vector2) -> void:
	if can_dash:
		dash_direction = direction
		dashing = true
		can_dash = false
		dash_timer.start()
		cooldown_timer.start()


func _on_dash_timer_timeout() -> void:
	dashing = false


func _on_dash_cooldown_timeout() -> void:
	can_dash = true
