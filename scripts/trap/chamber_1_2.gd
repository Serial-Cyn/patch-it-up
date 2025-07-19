extends AnimatableBody2D


@onready var area_2d: Area2D = $Area2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sound_effects: AudioStreamPlayer2D = %SoundEffects

var triggered : bool = false


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		triggered = true
		animation_player.play("move")
		
		await get_tree().create_timer(1.5).timeout
		
		sound_effects.play_sfx(sound_effects.SFX.EXPLOSION)
		queue_free()
		
