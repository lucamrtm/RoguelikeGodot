@icon("res://Art/v1.1 dungeon crawler 16X16 pixel pack/heroes/knight/knight_idle_anim_f0.png")

extends CharacterBody2D
class_name Player

signal healthChanged

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

# MOVEMENT
@export var max_speed: float = 150
@export var acceleration : float = 20



#HEALTH
@export var maxHealth = 3
var currentHealth: int = maxHealth


func updateAnimation():
	if velocity.length() == 0:
		animated_sprite_2d.play("idle_animation")
	else:
		animated_sprite_2d.play("walk_animation")

func handleCollision():
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		print_debug(collider.name)



func _physics_process(delta: float) -> void:
	
	var direction : Vector2 =Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	velocity.x = move_toward(velocity.x, max_speed * direction.x, acceleration)
	velocity.y= move_toward(velocity.y,max_speed * direction.y,acceleration)
	move_and_slide()
	
	# Flip the sprite based on the direction
	if direction.x != 0:
		animated_sprite_2d.flip_h = direction.x < 0
	
	handleCollision()
	updateAnimation()





# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_hurt_box_area_entered(area: Area2D) -> void:
	if area.name == "hitBox":
		currentHealth -= 1
		if currentHealth < 0:
			currentHealth = maxHealth
		healthChanged.emit(currentHealth)
