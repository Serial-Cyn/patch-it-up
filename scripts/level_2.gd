extends Node2D


@onready var chamber_1_death: Area2D = $Traps/Chamber1Death
@onready var game_manager: Node = %GameManager
@onready var start_game: Timer = %StartGame
@onready var player: CharacterBody2D = %Player

func _ready() -> void:
	player.reverse_control = -1

func _on_chamber_1_death_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		game_manager.damage_player(60)


func _on_start_game_timeout() -> void:
	game_manager.start_game = true
