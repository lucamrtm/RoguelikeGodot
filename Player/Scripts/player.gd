@icon("res://Art/v1.1 dungeon crawler 16X16 pixel pack/heroes/knight/knight_idle_anim_f0.png")

extends CharacterBody2D
class_name Player


@export var max_speed: float = 100
@export var acceleration : float = 10

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func updateAnimation():
	if velocity.length() == 0:
		animated_sprite_2d.play("idle_animation")
	else:
		animated_sprite_2d.play("walk_animation")
	

func _physics_process(delta: float) -> void:
	
	var direction : Vector2 =Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	velocity.x = move_toward(velocity.x, max_speed * direction.x, acceleration)
	velocity.y= move_toward(velocity.y,max_speed * direction.y,acceleration)
	move_and_slide()
	
	# Flip the sprite based on the direction
	if direction.x != 0:
		animated_sprite_2d.flip_h = direction.x < 0
	
	updateAnimation()





# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
