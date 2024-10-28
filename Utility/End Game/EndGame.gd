extends Control

@onready var game_over_win: Label = $"Vitória"
@onready var game_over_lose: Label = $Derrota

func _ready() -> void:
	# Define o Label como invisível no início
	game_over_win.visible = false
	game_over_lose.visible = false
# Função para exibir a tela de fim de jogo
func show_game_over_win():
	game_over_win.visible = true

func show_game_over_lose():
	game_over_lose.visible = true
