@icon("res://Art/v1.1 dungeon crawler 16X16 pixel pack/heroes/knight/knight_idle_anim_f0.png")

extends CharacterBody2D
class_name Player
@onready var animation_player: AnimationPlayer = $AnimationPlayer
#@onready var torch: Node2D = $"../../WeaponManager/Torch"

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var health: HealthComponent = $HealthComponent
@onready var hurtbox: HurtboxComponent = $HurtboxComponent
@onready var hitbox: HitboxComponent = $Weapon/HitboxComponent
@onready var dash: DashComponent = $DashComponent
@onready var dash_particles = $GPUParticles2D
@onready var player: Player = $"."
@onready var game_over: Control = $EndScreen/GameOver

# MOVEMENT
@export var max_speed: float = 150
@export var acceleration : float = 20
@export var anim_attk_speed : float = 1


# ATTACK
var direction : Vector2 = Vector2.ZERO
var is_attacking: bool = false
var weapon: Weapon


# VIDA
var is_dead: bool = false



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var torch = get_node("Torch")  # Caminho relativo dentro de WeaponManager
	weapon = $"../WeaponManager/Torch"  # Configura a Torch como arma inicial
	if weapon:
		print("Arma inicial equipada:", weapon.name)
	else:
		print("Erro: Torch não encontrada!")
		
	animation_player.animation_finished.connect(_on_animation_finished)

	hurtbox.hit_by_hitbox.connect(_on_hit_by_hitbox)
	health.died.connect(_on_died)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	if dash.is_dashing():
		(animated_sprite_2d.material as ShaderMaterial).set_shader_parameter("enabled", true)
	else:
		(animated_sprite_2d.material as ShaderMaterial).set_shader_parameter("enabled", false)


func _physics_process(delta: float) -> void:
	if is_dead:
		return  # Se o jogador está morto, ignora o movimento
	
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
	if !dash.is_dashing():
		hurtbox.enable_collision()
		enable_collision_with_mask(2)
		direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	if Input.is_action_just_pressed("dash"):
		dash.do_dash(direction)
		dash_particles.look_at(direction)
		dash_particles.emitting = true
	
	if dash.is_dashing():
		hurtbox.disable_collision()
		disable_collision_with_mask(2)
		velocity.x = move_toward(velocity.x, dash.dash_speed * dash.dash_direction.x, acceleration)
		velocity.y = move_toward(velocity.y, dash.dash_speed * dash.dash_direction.y, acceleration)
	else:
		velocity.x = move_toward(velocity.x, max_speed * direction.x, acceleration)
		velocity.y = move_toward(velocity.y, max_speed * direction.y, acceleration)


func disable_collision_with_mask(mask: int) -> void:
	collision_mask &= ~(1 << (mask - 1))  # Remove a máscara correspondente

func enable_collision_with_mask(mask: int) -> void:
	collision_mask |= (1 << (mask - 1))  # Adiciona a máscara correspondente


func handleCollision():
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		#print_debug(collider.name)


func _on_animation_finished(anim_name: String) -> void:
	# Verifica se a animação que terminou foi a de ataque
	if anim_name == "attack_animation" or anim_name == "running_attack_animation":
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
		if velocity == Vector2.ZERO:
			is_attacking = true
			animation_player.play("attack_animation", 0, anim_attk_speed)
			# ativa a attackBox quando esta atacando, trocando a camada de colisão
		else:
			is_attacking = true
			animation_player.play("running_attack_animation", 0, anim_attk_speed)
			# ativa a attackBox quando esta atacando, trocando a camada de colisão
			
			
		




func _on_hit_by_hitbox(hitbox: HitboxComponent) -> void:
	health.damage(hitbox.hitStats.damage)

func set_shot_speed(amount: int) -> void:
	if weapon:  # Verifica se a arma está atribuída
		weapon.set_shoot_speed((amount))
		anim_attk_speed += 1




func _on_died() -> void:
	game_over.show_game_over_lose()
	is_dead = true
	animation_player.play("idle_animation")
