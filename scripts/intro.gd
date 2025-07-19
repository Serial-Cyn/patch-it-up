extends Node2D

@onready var player: CharacterBody2D = %Player
@onready var start_game: Timer = %StartGame
@onready var sound_effects: AudioStreamPlayer2D = %SoundEffects
@onready var corruption_label: Label = %CorruptionLabel
@onready var game_manager: Node = %GameManager
@onready var alarm_effects: Node2D = $Player/AlarmEffects
@onready var death_platform: AnimatableBody2D = $DeathPlatform/Platform
@onready var animation_player: AnimationPlayer = $DeathPlatform/Platform/AnimationPlayer
@onready var spikes: Node2D = $DeathPlatform/Platform/Spikes

var death_triggered : bool = false

func _ready() -> void:
	corruption_label.visible = false
	death_platform.visible = false
	spikes.visible = false
	
	for spike in spikes.get_children():
		spike.get_node("HurtBox").monitoring = false

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
	sound_effects.play_sfx(sound_effects.SFX.ERROR)
	
	await get_tree().create_timer(2.5).timeout
	sound_effects.play_sfx(sound_effects.SFX.ERROR)
	
	await get_tree().create_timer(2.5).timeout
	sound_effects.play_sfx(sound_effects.SFX.GOAL)


func _on_trigger_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and not death_triggered:
		for spike in spikes.get_children():
			spike.get_node("HurtBox").monitoring = true
		
		death_triggered = true
		death_platform.visible = true
		player.shake_screen(1.0)
		sound_effects.play_sfx(sound_effects.SFX.EXPLOSION)
		
		await get_tree().create_timer(1.0).timeout # Adjust for actual duration
		
		spikes.visible = true
		player.shake_screen(1.0)
		sound_effects.play_sfx(sound_effects.SFX.EXPLOSION)
		
		await get_tree().create_timer(1.0).timeout # Adjust for actual duration
		
		animation_player.play("move")
