extends Node2D


@onready var spike: AnimatableBody2D = $Spike
@onready var spike_2: AnimatableBody2D = $Spike2
@onready var death_platform: Node2D = $DeathPlatform
@onready var sound_effects: AudioStreamPlayer2D = %SoundEffects
@onready var platform_up: AnimationPlayer = $Platform/PlatformUp
@onready var animation_player: AnimationPlayer = $DeathPlatform/Platform/AnimationPlayer
@onready var patch_2: CharacterBody2D = $"../../Patch2"
@onready var game_manager: Node = %GameManager
@onready var spike_3: AnimatableBody2D = $Spike3
@onready var spike_4: AnimatableBody2D = $Spike4
@onready var patch: CharacterBody2D = %Patch
@onready var spike_5: AnimatableBody2D = $Spike5
@onready var last_spike_death: Area2D = $Spike5/LastSpikeDeath


var trigger : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	trigger_trap()
	trigger_last_spike()
	spike.DAMAGE = 60 
	spike_2.DAMAGE = 60 
	patch.visible = trigger
	spike_3.visible = trigger
	spike_4.visible = trigger

func trigger_last_spike():
	spike_5.visible = trigger
	last_spike_death.monitoring = trigger

func trigger_trap():
	spike.visible = trigger
	spike_2.visible = trigger
	death_platform.visible = trigger
	spike.get_node("HurtBox").monitoring = trigger
	spike_2.get_node("HurtBox").monitoring = trigger
	spike.get_node("Collider").disabled = !trigger
	spike_2.get_node("Collider").disabled = !trigger


func _on_trigger_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and not trigger:
		trigger = true
		patch.visible = trigger
		
		trigger_trap()
		sound_effects.play_sfx(sound_effects.SFX.EXPLOSION)
		patch_2.queue_free()
		
		await get_tree().create_timer(1.5).timeout
		animation_player.play("move")
		
		await get_tree().create_timer(2.0).timeout
		platform_up.play("move")
		
		await get_tree().create_timer(2.0).timeout
		
		sound_effects.play_sfx(sound_effects.SFX.EXPLOSION)
		spike_3.visible = trigger
		spike_4.visible = trigger


func _on_chamber_2_death_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		game_manager.damage_player(60)


func _on_last_spike_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		trigger_last_spike()


func _on_last_spike_death_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		game_manager.damage_player(60)
