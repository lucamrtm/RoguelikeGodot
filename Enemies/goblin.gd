extends CharacterBody2D

@export var speed = 90
@onready var game: Node = get_node("/root/Game")
var currentLevel: Node 
var control: GameUI


@onready var eyes = $eyes
@onready var luz_olhos_1: PointLight2D = $olhos/LuzOlhos1
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D 
@onready var animation_player = $HitAnimationPlayer
@onready var player = get_tree().get_first_node_in_group("player")
@onready var hurtbox: HurtboxComponent = $HurtboxComponent
@onready var hitbox: HitboxComponent = $HitboxComponent
@onready var health_component: HealthComponent = $HealthComponent

const GOBLIN = preload("res://Enemies/goblin.tscn")

var startPosition
var endPosition
var move_direction

var dead = false

func _ready() -> void:
	animated_sprite_2d.animation_finished.connect(_on_animated_sprite_2d_animation_finished)
	
	control = get_node("/root/Game/NextLevel/Level_1/CanvasLayer2/Control")
	
	startPosition = global_position # startPosition = posição atual do personagem.
	if not dead:
		update_target_position(player.global_position)
		hurtbox.hit_by_hitbox.connect(_on_hit_by_hitbox)
	health_component.died.connect(_on_died)


# atualiza endPosition para a posição do jogador
func update_target_position(position : Vector2 ):
	endPosition = position


func change_direction():
	# atualiza a endPosition para a posição do jogador novamente
	update_target_position(player.global_position)
	# define a nova posição inicial como a atual
	startPosition = global_position


func update_velocity():
	if not dead:
		move_direction = endPosition - global_position
		change_direction()
		velocity = move_direction.normalized() * speed

func update_animation():
	if not dead:
		animated_sprite_2d.play("walk")

func _physics_process(delta: float) -> void:
	update_velocity()
	move_and_slide()
	# Flip the sprite based on the direction
	if move_direction.x != 0:
		animated_sprite_2d.flip_h = move_direction.x < 0
		eyes.scale.x = 1 if move_direction.x > 0 else -1
		
	update_animation()

func spawnNewGoblin(position : Vector2):
	var new_goblin = GOBLIN.instantiate() # cria uma nova instância de goblin
	get_parent().add_child(new_goblin) # adiciona o goblin como filho do mesmo pai
	new_goblin.global_position = position 


func _on_hit_by_hitbox(hitbox: HitboxComponent) -> void:
	print("Hitbox atacando o goblin! Goblin sofreu dano.")
	health_component.damage(hitbox.hitStats.damage)
	animation_player.play("hit")
	

func _on_died() -> void:
	print("Goblin morreu!")
	dead = true
	update_target_position(position)
	print("Chamando a animação de morte")
	animated_sprite_2d.play("death_animation")
	print("Animação atual:", animated_sprite_2d.animation)
	GlobalController.updateScore(-1)
	# Conecta o sinal de término da animação para chamar o `queue_free` depois
	





func _on_animated_sprite_2d_animation_finished() -> void:
	print("Animação finalizada! Goblin será removido.")
	queue_free()
