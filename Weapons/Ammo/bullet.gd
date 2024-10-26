extends Area2D

@export var speed = 200
@export var damage = 1


var direction : Vector2

func _ready() -> void:
	await get_tree().create_timer(3).timeout

func setDirection(bulletDirection):
	direction = bulletDirection
	rotation_degrees = rad_to_deg(global_position.angle_to_point(global_position + direction))

func _physics_process(delta: float) -> void:
	global_position += direction * speed * delta


func _on_body_entered(body: Node2D) -> void:
	pass


func _on_hitbox_component_body_entered(body: Node2D) -> void:
	print("Colisão detectada com: ", body.name, " (tipo: ", body.get_class(), ")")
	if body.name == "goblin":
		print("Goblin toma 1 de dano")
		queue_free()
		
