extends Node

@onready var corruption_timer: Timer = $CorruptionTimer
@onready var corruption_label: Label = %CorruptionLabel

var patch_sfx = preload("res://assets/sounds/power_up.wav")

var has_moved : bool = false
var timer_has_started : bool = false

func _process(_delta):
	
	if not timer_has_started and has_moved:
		corruption_timer.start()
		
		timer_has_started = true
	
	if timer_has_started:
		update_timer(corruption_timer.time_left)


func update_timer(time_left : float):
	if time_left > 5.0:
		corruption_label.text = str(int(time_left))		# Show whole numbers
	else:
		corruption_label.text = "%.2f" % (time_left)	# Show 2 decimal places
