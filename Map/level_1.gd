extends TileMapLayer

signal level_exit_entered

@onready var area = $Area2D
@onready var spawnpoint = $Marker2D

@onready var upper_left_limit = $UpperLeftLimit
@onready var bottom_right_limit = $BottomRightLimit

func _ready() -> void:
	area.monitoring = false


func enable_exit() -> void:
	area.monitoring = true


func _on_area_2d_body_entered(body: Player) -> void:
	level_exit_entered.emit()
	print("emitido")


func _on_area_2d_body_exited(body: Player) -> void:
	area.monitoring = true
