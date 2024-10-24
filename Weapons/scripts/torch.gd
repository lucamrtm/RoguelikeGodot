extends Weapon

@onready var sprite = $Sprite2D
@onready var hitbox = $Sprite2D/HitboxComponent
@onready var animation = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	look_at(get_global_mouse_position())


func use() -> void:
	animation.play("slash")
