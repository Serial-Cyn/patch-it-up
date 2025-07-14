extends Node2D

@onready var sprite: Sprite2D = $Sprite
@onready var collider: CollisionShape2D = $StaticBody/Collider


var is_visible : bool = true

func _on_timer_timeout() -> void:
	is_visible = !is_visible
	sprite.visible = is_visible
	collider.disabled = !is_visible
