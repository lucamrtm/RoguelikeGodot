extends Area2D

@onready var torch: Node2D = $WeaponManager/Torch
@onready var animated_sprite_2d: AnimatedSprite2D = $CanvasLayer/AnimatedSprite2D
@onready var control_attk_speed: Control = $CanvasLayer/Control_attk_speed_visibility


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.set_shot_speed(10)
		add_to_group("boosts")  # Adiciona este nó ao grupo "boosts"
		
		# Encontra o Control e chama a função
		var control_node = get_node("/root/Game/CanvasLayer/Control_attk_speed_visibility")
		if control_node:
			control_node.show_on_canvas()
		
		get_parent().queue_free()
		print("Pai e filho liberados.")
