extends Node2D

@onready var player: CharacterBody2D = %Player
@onready var start_game: Timer = %StartGame
@onready var sound_effects: AudioStreamPlayer2D = %SoundEffects


func _on_start_game_timeout() -> void:
	player.gravity_direction = -1
	player.reverse_control = -1
	
	player.shake_screen(10.0)
	sound_effects.play_sfx(sound_effects.SFX.EXPLOSION)
