extends Node

@onready var corruption_timer: Timer = $CorruptionTimer
@onready var corruption_label: Label = %CorruptionLabel
@onready var restart_timer: Timer = $RestartTimer
@onready var player: CharacterBody2D = %Player

var patch_sfx = preload("res://assets/sounds/power_up.wav")

var timer_has_started : bool = false
var start_game : bool = false


func _process(_delta):
	if start_game and not timer_has_started:
		corruption_timer.start()
		
		timer_has_started = true
		
	if timer_has_started:
		update_timer(corruption_timer.time_left)


func update_timer(time_left : float):
	if time_left > 5.0:
		corruption_label.text = str(int(time_left))		# Show whole numbers
		
	else:
		corruption_label.text = "%.2f" % (time_left)	# Show 2 decimal places
		corruption_label.modulate = Color(1, 0, 0)

	
func _on_corruption_timer_timeout() -> void:
	player.dead = true
	restart_timer.start()


func _on_restart_timer_timeout() -> void:
	get_tree().reload_current_scene()
