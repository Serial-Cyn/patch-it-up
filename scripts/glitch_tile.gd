extends Node2D

@onready var sprite: Sprite2D = $Sprite
@onready var collider: CollisionShape2D = $StaticBody/Collider
@onready var timer: Timer = $Timer

var is_visible: bool = true
var random_tile : Vector2

func _ready():
	# Set random wait time between 0.5 to 2 seconds (you can change the range)
	randomize_glitch_interval()

func randomize_glitch_interval() -> void:
	timer.wait_time = randf_range(0.5, 2.0)
	timer.start()

func randomize_tile() -> void:
	random_tile = Vector2(
		randi_range(1, 3), randi_range(7, 9)
	)
	
	sprite.frame_coords = random_tile

func glitch_tile() -> void:
	randomize_tile()
	
	is_visible = !is_visible
	sprite.visible = is_visible
	collider.disabled = !is_visible

func _on_timer_timeout() -> void:
	glitch_tile()
