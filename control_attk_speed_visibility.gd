extends Control

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animated_sprite_2d.visible = false
	
	

func show_on_canvas() -> void:
	animated_sprite_2d.visible = true

func check_and_show_boost() -> void:
	var boost = get_tree().get_first_node_in_group("boosts")
	if boost:
		show_on_canvas()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
