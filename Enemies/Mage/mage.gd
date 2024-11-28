extends CharacterBody2D

@export var speed: float = 90
@export var min_distance: float = 50  # Distância mínima antes de começar a fugir
@export var max_distance: float = 100  # Distância máxima antes de se aproximar

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var player = get_tree().get_first_node_in_group("player")
@onready var timer = Timer.new()

# Estados possíveis do inimigo
enum State { FOLLOW, FLEE, IDLE }
var state: int = State.IDLE  # Estado inicial

var move_direction: Vector2
var dead: bool = false

func _ready() -> void:
	add_child(timer)
	timer.wait_time = 1  # Tempo para fugir antes de reconsiderar
	timer.one_shot = true
	move_direction = Vector2.ZERO

func _physics_process(delta: float) -> void:
	if dead:
		return  # Não faz nada se estiver morto

	update_state()
	move_and_slide()

	update_animation()
	flip_sprite()

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
		animated_sprite_2d.flip_h = velocity.x < 0
