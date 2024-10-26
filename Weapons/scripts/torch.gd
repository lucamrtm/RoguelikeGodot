extends Weapon

@export var shootSpeed = 1.0

const BULLET = preload("res://Weapons/Ammo/Bullet.tscn")
@onready var sprite = $Sprite2D
@onready var hitbox = $Sprite2D/HitboxComponent
@onready var animation = $AnimationPlayer
@onready var marker_2d: Marker2D = $Marker2D
@onready var shoot_speed_timer: Timer = $ShootSpeedTimer
@onready var hurtbox_component: HurtboxComponent = $HurtboxComponent

var canShoot = true
var bulletDirection = Vector2(1,0)



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	shoot_speed_timer.wait_time = 1.0 / shootSpeed
	
func shoot():
	if canShoot:
		canShoot = false
		shoot_speed_timer.start()
		
		var bulletNode = BULLET.instantiate()
		
		bulletNode.setDirection(bulletDirection)
		get_tree().root.add_child(bulletNode)
		bulletNode.global_position = marker_2d.global_position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	look_at(get_global_mouse_position())


func use() -> void:
	animation.play("slash")


func _on_shoot_speed_timer_timeout() -> void:
	canShoot = true
	
func setup_direction(direction):
	bulletDirection = direction
	
	if direction.x > 0:
		scale.x = 1
		rotation_degrees = 0
	elif direction.x < 0:
		scale.x = -1
		rotation_degrees = 0
	elif direction.y < 0:
		scale.x = 1
		rotation_degrees = -90
	elif direction.y > 0:
		scale.x = 1
		rotation_degrees = 90
