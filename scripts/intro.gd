extends Node2D


@onready var player: CharacterBody2D = %Player
@onready var start_game: Timer = %StartGame


func _on_start_game_timeout() -> void:
	player.gravity_direction = -1
	player.reverse_control = -1
