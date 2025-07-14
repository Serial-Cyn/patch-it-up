extends Node

@onready var corruption_timer: Timer = $CorruptionTimer

func _ready():
	corruption_timer.start()
	

func _process(_delta):
	print(corruption_timer.time_left)
