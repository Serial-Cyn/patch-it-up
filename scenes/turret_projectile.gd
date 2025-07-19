extends Area2D


@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var timer: Timer = $Timer


func  _ready() -> void:
	extend_laser(1500.0)
	
	timer.start()

func extend_laser(length: float):
	
	sprite_2d.scale.x = length / sprite_2d.texture.get_width()


func _on_timer_timeout() -> void:
	queue_free()
