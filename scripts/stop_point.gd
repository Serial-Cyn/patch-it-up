extends Node2D

@onready var stop_area: Area2D = $StopArea
@onready var sprite: AnimatedSprite2D = $Sprite

func _on_stop_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.is_in_safe_zone = true
		sprite.play("glow")

func _on_stop_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.is_in_safe_zone = false
		sprite.play("dim")
