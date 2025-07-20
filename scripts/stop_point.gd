extends Node2D

@onready var stop_area: Area2D = $StopArea
@onready var sprite: AnimatedSprite2D = $Sprite
@onready var sfx: AudioStreamPlayer2D = $SFX
@onready var label: Label = $CanvasLayer/Label

func _ready() -> void:
	label.visible = false
	
func _on_stop_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.is_in_safe_zone = true
		sprite.play("glow")
		sfx.pitch_scale = randf_range(0.95, 1.05)
		sfx.play()
		label.visible = true

func _on_stop_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.is_in_safe_zone = false
		sprite.play("dim")
		sfx.stop()
		label.visible = false
