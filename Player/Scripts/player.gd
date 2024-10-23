@icon("res://Art/v1.1 dungeon crawler 16X16 pixel pack/heroes/knight/knight_idle_anim_f0.png")

extends CharacterBody2D
class_name Player

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var health: HealthComponent = $HealthComponent
@onready var hurtbox: HurtboxComponent = $HurtboxComponent
@onready var hitbox: HitboxComponent = $HitboxComponent
@onready var dash: DashComponent = $DashComponent

# MOVEMENT
@export var max_speed: float = 150
@export var acceleration : float = 20

# ATTACK
var is_attacking: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hitbox.set_collision_layer_value(1, false) # inicializa attackBox como desativada
	hurtbox.hit_by_hitbox.connect(_on_hit_by_hitbox)
	health.died.connect(_on_died)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("attack"):  # 
		attack()


func _physics_process(delta: float) -> void:
	manage_input()
	move_and_slide()
	
	# muda a direção da sprite de acordo com o movimento
	if velocity.x != 0:
		animated_sprite_2d.flip_h = velocity.x < 0
	
	handleCollision()
	updateAnimation()


func manage_input() -> void:
	var direction
	
	if !dash.is_dashing():
		direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	if Input.is_action_just_pressed("dash"):
		dash.do_dash(direction)
	
	if dash.is_dashing():
		velocity.x = move_toward(velocity.x, dash.dash_speed * dash.dash_direction.x, acceleration)
		velocity.y = move_toward(velocity.y, dash.dash_speed * dash.dash_direction.y, acceleration)
	else:
		velocity.x = move_toward(velocity.x, max_speed * direction.x, acceleration)
		velocity.y = move_toward(velocity.y, max_speed * direction.y, acceleration)

func handleCollision():
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		#print_debug(collider.name)


func updateAnimation():
	if is_attacking:
		return  # se o personagem está atacando não faz nada aqui pra não sobrepor a animação
	elif velocity.length() == 0:
		animated_sprite_2d.play("idle_animation")
	else:
		animated_sprite_2d.play("walk_animation")


func attack():
	if not is_attacking:  # garantir que não bate varias vezes ao mesmo tempo
		is_attacking = true
		animated_sprite_2d.play("attack_animation")
		# ativa a attackBox quando esta atacando, trocando a camada de colisão
		hitbox.set_collision_layer_value(1, true)
		
		await get_tree().create_timer(0.2).timeout # tempo para desligar animação
		
		is_attacking = false
		hitbox.set_collision_layer_value(1, false)


func _on_hit_by_hitbox(hitbox: HitboxComponent) -> void:
	health.damage(hitbox.hitStats.damage)


func _on_died() -> void:
	health.heal(health.maxHealth)
