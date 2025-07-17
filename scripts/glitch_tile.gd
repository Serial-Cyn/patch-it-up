extends Node2D

@onready var sprite: Sprite2D = $Sprite
@onready var collider: CollisionShape2D = $StaticBody/Collider
@onready var timer: Timer = $Timer

var is_visible: bool = true

func _ready():
	# Set random wait time between 0.5 to 2 seconds (you can change the range)
	timer.wait_time = randf_range(0.5, 2.0)
	timer.start()

func _on_timer_timeout() -> void:
	is_visible = !is_visible
	sprite.visible = is_visible
	collider.disabled = !is_visible
