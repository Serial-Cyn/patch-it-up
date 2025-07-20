extends Node2D

@onready var death_platform: Node2D = $DeathPlatform
@onready var spikes: Node2D = $DeathPlatform/Platform/Spikes
@onready var sound_effects: AudioStreamPlayer2D = %SoundEffects
@onready var death_platform_2: Node2D = $DeathPlatform2
@onready var spikes2: Node2D = $DeathPlatform2/Platform/Spikes
@onready var boss: CharacterBody2D = %Boss

var triggered : bool = false
var trigger_count : int = 0

func _ready() -> void:
	trigger_trap()
	block_patch(false)


func trigger_trap():
	death_platform.visible = triggered
	
	for spike in spikes.get_children():
		spike.get_node("HurtBox").monitoring = triggered
		spike.get_node("Collider").disabled = !triggered


func block_patch(show : bool):
	death_platform_2.visible = show
	
	for spike in spikes2.get_children():
		spike.get_node("HurtBox").monitoring = show
		spike.get_node("Collider").disabled = !show

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		boss.triggered = true
		trigger_count += 1
		
		if trigger_count > 1:
			if not triggered:
				triggered = true
				
				trigger_trap()
				
				sound_effects.play_sfx(sound_effects.SFX.EXPLOSION)

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		trigger_count += 1


func _on_area_2d_2_body_entered(body: Node2D) -> void:
	block_patch(true)
