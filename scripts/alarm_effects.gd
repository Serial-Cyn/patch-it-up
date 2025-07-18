extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var color_rect: ColorRect = $CanvasLayer/ColorRect
@onready var duration_timer: Timer = $DurationTimer
@onready var alarm_sound: AudioStreamPlayer2D = $AlarmSound

func _ready() -> void:
	color_rect.visible = false

func blare_alarm():
	duration_timer.start()

	alarm_sound.play()
	
	color_rect.visible = true
	animation_player.play("blare")

func stop_alarm():
	alarm_sound.stop()
	
	color_rect.visible = false
	animation_player.stop()

func _on_duration_timer_timeout() -> void:
	stop_alarm()
