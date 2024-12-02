extends CharacterBody2D

@onready var eyes = $eyes
@onready var luz_olhos_1: PointLight2D = $olhos/LuzOlhos1
@onready var animation_player = $HitAnimationPlayer
@onready var hurtbox: HurtboxComponent = $HurtboxComponent
@onready var hitbox: HitboxComponent = $HitboxComponent
@onready var health_component: HealthComponent = $HealthComponent

@onready var game: Node = get_node("/root/Game")
var currentLevel: Node 
var control: Control 

@export var shootSpeed = 1.0
const BULLET = preload("res://Weapons/Ammo/EnemyBullet.tscn")
@onready var shoot_speed_timer: Timer = $ShootSpeedTimer
var canShoot = true
var bulletDirection
@onready var marker_2d: Marker2D = $AnimatedSprite2D/Marker2D

const GOBLIN = preload("res://Enemies/Mage/Mage.tscn")


@export var speed: float = 90
@export var min_distance: float = 50  # Distância mínima antes de começar a fugir
@export var max_distance: float = 100  # Distância máxima antes de se aproximar

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var player = get_tree().get_first_node_in_group("player")
@onready var timer = Timer.new()

@onready var torres = get_tree().get_nodes_in_group("torres")

# Estados possíveis do inimigo
enum State { FOLLOW, FLEE, IDLE }
var state: int = State.IDLE  # Estado inicial

var move_direction: Vector2
var dead: bool = false

func _ready() -> void:
	
	#currentLevel = game.get_level()
	#if currentLevel:
		#var canvas_layer = currentLevel.get_node("CanvasLayer")
		#control = canvas_layer.get_node("Control")
	
	
	shoot_speed_timer.wait_time = shootSpeed  # Configura o tempo entre disparos
	shoot_speed_timer.one_shot = true  # Impede disparos consecutivos
	shoot_speed_timer.timeout.connect(_on_shoot_speed_timer_timeout)  # Conecta o temporizador ao método
	
	hurtbox.hit_by_hitbox.connect(_on_hit_by_hitbox)
	animated_sprite_2d.animation_finished.connect(_on_animated_sprite_2d_animation_finished)
	add_child(timer)
	timer.wait_time = 1  # Tempo para fugir antes de reconsiderar
	timer.one_shot = true
	move_direction = Vector2.ZERO
	health_component.died.connect(_on_died)

func _physics_process(delta: float) -> void:
	if dead:
		return  # Não faz nada se estiver morto
		
		
	var torres = get_tree().get_nodes_in_group("torres")
	
	update_state()
	move_and_slide()
	flip_sprite()
	update_animation()
	
	# Atualiza a direção da bala para apontar sempre na direção do jogador
	bulletDirection = (player.global_position - global_position).normalized()

func update_state():
	var distance_to_player = position.distance_to(player.position)

	# Se está fugindo
	if state == State.FLEE:
		if timer.is_stopped():  # Se o temporizador expira, reconsidera o estado
			state = State.FOLLOW if distance_to_player > max_distance else State.IDLE

	# Decide novo estado com base na distância
	elif distance_to_player < min_distance:
		state = State.FLEE
		start_fleeing()
	elif distance_to_player > max_distance:
		state = State.FOLLOW
		start_following()
	else:
		state = State.IDLE
		if canShoot:
			shoot()

	# Atualiza a direção e a velocidade com base no estado
	update_velocity()

func start_fleeing():
	timer.start()
	move_direction = (position - player.position).normalized()
	velocity = move_direction * speed

func start_following():
	move_direction = (player.position - position).normalized()
	velocity = move_direction * speed

func update_velocity():
	if state == State.FLEE:
		velocity = move_direction * speed
	elif state == State.FOLLOW:
		velocity = move_direction * speed
	else:
		velocity = Vector2.ZERO  # IDLE: sem movimento

func update_animation():
	if velocity.length() > 0:
		animated_sprite_2d.play("walk")
	else:
		animated_sprite_2d.play("idle")

func flip_sprite():
	if velocity.x != 0:
		# Altera a escala para flipar horizontalmente
		animated_sprite_2d.scale.x = -1 if velocity.x < 0 else 1


func _on_hit_by_hitbox(hitbox: HitboxComponent) -> void:
	print("Hitbox atacando o goblin! Boss sofreu dano.")
	health_component.damage(hitbox.hitStats.damage)
	print(hitbox.hitStats.damage)
	
	var valid_torres = []
	for torre in torres:
		if is_instance_valid(torre):
			valid_torres.append(torre)
	
	if valid_torres.size() > 0:
		print("Ainda existem torres!")
		health_component.damage(-hitbox.hitStats.damage)
		print(-hitbox.hitStats.damage)
	else:
		print("Não há mais torres!")


func shoot():
	if canShoot:
		canShoot = false
		shoot_speed_timer.start()
		
		var bulletNode = BULLET.instantiate()
		
		bulletNode.setDirection(bulletDirection)
		get_tree().root.add_child(bulletNode)
		bulletNode.global_position = marker_2d.global_position


func _on_died() -> void:
	print("Goblin morreu!")
	dead = true
	move_direction = Vector2.ZERO
	print("Chamando a animação de morte")
	animated_sprite_2d.play("death_animation")
	print("Animação atual:", animated_sprite_2d.animation)
	GlobalController.updateScore(-1)
	
	var gameOver = get_tree().get_first_node_in_group("tela_final")
	gameOver.show_game_over_win()
	queue_free()
	
	
	# Conecta o sinal de término da animação para chamar o `queue_free` depois
	

func _on_animated_sprite_2d_animation_finished() -> void:
	queue_free()


func _on_shoot_speed_timer_timeout() -> void:
	canShoot = true
