extends CharacterBody2D

@onready var control: Control = get_node("../CanvasLayerLvl2/Control")


@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D 
@onready var animation_player = $HitAnimationPlayer
@onready var player = get_tree().get_first_node_in_group("player")
@onready var hurtbox: HurtboxComponent = $HurtboxComponent
@onready var hitbox: HitboxComponent = $HitboxComponent
@onready var health_component: HealthComponent = $HealthComponent

const TORRE = preload("res://Enemies/torre.tscn")

var dead = false

func _ready() -> void:
	animated_sprite_2d.animation_finished.connect(_on_animated_sprite_2d_animation_finished)

	
	if not dead:
		
		hurtbox.hit_by_hitbox.connect(_on_hit_by_hitbox)
	health_component.died.connect(_on_died)


func update_animation():
	if not dead:
		animated_sprite_2d.play("idle")

func _physics_process(delta: float) -> void:
	update_animation()



func _on_hit_by_hitbox(hitbox: HitboxComponent) -> void:
	print("Hitbox atacando a torre! Torre sofreu dano.")
	health_component.damage(hitbox.hitStats.damage)
	animation_player.play("hit")
	

func _on_died() -> void:
	print("Torre Destruída!")
	dead = true
	print("Chamando a animação de morte")
	animated_sprite_2d.play("death_animation")
	print("Animação atual:", animated_sprite_2d.animation)
	control.updateScore()
	# Conecta o sinal de término da animação para chamar o `queue_free` depois
	





func _on_animated_sprite_2d_animation_finished() -> void:
	print("Animação finalizada! Goblin será removido.")
	queue_free()
