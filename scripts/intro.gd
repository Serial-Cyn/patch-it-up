extends Node2D

@onready var player: CharacterBody2D = %Player
@onready var start_game: Timer = %StartGame
@onready var sound_effects: AudioStreamPlayer2D = %SoundEffects
@onready var corruption_label: Label = %CorruptionLabel
@onready var game_manager: Node = %GameManager
@onready var alarm_effects: Node2D = $Player/AlarmEffects


func _ready() -> void:
	corruption_label.visible = false

func _on_start_game_timeout() -> void:
	player.reverse_control = -1
	player.gravity_direction = -1
	
	# Starts the corruption timer
	game_manager.start_game = true
	corruption_label.visible = true
	
	# Effects stuff
	alarm_effects.blare_alarm()
	player.shake_screen(10.0)
	sound_effects.play_sfx(sound_effects.SFX.EXPLOSION)
