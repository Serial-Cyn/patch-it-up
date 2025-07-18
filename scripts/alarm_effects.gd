extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var color_rect: ColorRect = $CanvasLayer/ColorRect

func _ready() -> void:
	color_rect.visible = false

func blare_alarm():
	color_rect.visible = true
	animation_player.play("blare")

func stop_alarm():
	color_rect.visible = false
	animation_player.stop()
