extends CharacterBody2D

@export var speed = 90
@export var limit : float = 0.5

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D 
@onready var player: Player = $"../Player" # caminho para o node do player
@onready var health: HealthComponent = $HealthComponent
@onready var hurtbox: HurtboxComponent = $HurtboxComponent
@onready var hitbox: HitboxComponent = $HitboxComponent

const GOBLIN = preload("res://Enemies/goblin.tscn")

var startPosition
var endPosition
var move_direction

func _ready() -> void:
	startPosition = position # startPosition = posição atual do personagem.
	update_target_position()
	hurtbox.hit_by_hitbox.connect(_on_hit_by_hitbox)
	health.died.connect(_on_died)


# atualiza endPosition para a posição do jogador
func update_target_position():
	endPosition = player.position


func change_direction():
	# atualiza a endPosition para a posição do jogador novamente
	update_target_position()
	# define a nova posição inicial como a atual
	startPosition = position


func update_velocity():
	move_direction = endPosition - position
	if move_direction.length() < limit:
		change_direction()
	velocity = move_direction.normalized() * speed

func update_animation():
	animated_sprite_2d.play("walk")

func _physics_process(delta: float) -> void:
	update_velocity()
	move_and_slide()
	
	# Flip the sprite based on the direction
	if move_direction.x != 0:
		animated_sprite_2d.flip_h = move_direction.x < 0
	
	update_animation()

func spawnNewGoblin(position : Vector2):
	var new_goblin = GOBLIN.instantiate() # cria uma nova instância de goblin
	get_parent().add_child(new_goblin) # adiciona o goblin como filho do mesmo pai
	new_goblin.position = position 


func _on_hit_by_hitbox(hitbox: HitboxComponent) -> void:
	print("Hitbox atacando o goblin! Goblin sofreu dano.")
	health.damage(hitbox.hitStats.damage)


func _on_died() -> void:
	print("Goblin morreu! Spawnando outro goblin.")
	queue_free()
	spawnNewGoblin( get_viewport_rect().size / 2)
