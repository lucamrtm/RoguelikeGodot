@icon("res://Art/v1.1 dungeon crawler 16X16 pixel pack/heroes/knight/knight_idle_anim_f0.png")

extends CharacterBody2D
class_name Player
@onready var animation_player: AnimationPlayer = $AnimationPlayer
#@onready var torch: Node2D = $"../../WeaponManager/Torch"

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var health: HealthComponent = $HealthComponent
@onready var hurtbox: HurtboxComponent = $HurtboxComponent
@onready var hitbox: HitboxComponent = $Weapon/HitboxComponent
@onready var dash: DashComponent = $DashComponent

# MOVEMENT
@export var max_speed: float = 150
@export var acceleration : float = 20

# ATTACK
var direction : Vector2 = Vector2.ZERO
var is_attacking: bool = false
var weapon: Weapon

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player.animation_finished.connect(_on_animation_finished)

	hurtbox.hit_by_hitbox.connect(_on_hit_by_hitbox)
	health.died.connect(_on_died)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	manage_input()
	move_and_slide()
	
	scale.x = -1 if abs(get_angle_to(get_global_mouse_position())) > 1.5 else 1
	
	handleCollision()
	updateAnimation()
	
	var mouse_position = get_global_mouse_position()
	var direction = (mouse_position - global_position).normalized()
	
	
	if Input.is_action_just_pressed("attack"):  # 
		attack()
	if direction != Vector2.ZERO:
		weapon.setup_direction(direction)


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

func _on_animation_finished(anim_name: String) -> void:
	# Verifica se a animação que terminou foi a de ataque
	if anim_name == "attack_animation":
		weapon.shoot()
		is_attacking = false
		# Agora que o ataque terminou, muda para a animação idle
		animation_player.play("idle_animation")


func updateAnimation():
	if is_attacking:
		return  # se o personagem está atacando não faz nada aqui pra não sobrepor a animação
	elif velocity.length() == 0:
		animation_player.play("idle_torch_animation")
	else:
		animation_player.play("walk_animation")


func attack():
	if not is_attacking:  # garantir que não bate varias vezes ao mesmo tempo
		is_attacking = true
		animation_player.play("attack_animation")
		# ativa a attackBox quando esta atacando, trocando a camada de colisão


func _on_hit_by_hitbox(hitbox: HitboxComponent) -> void:
	health.damage(hitbox.hitStats.damage)


func _on_died() -> void:
	health.heal(health.maxHealth)
