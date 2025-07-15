extends AudioStreamPlayer2D

enum SFX { PICK_UP, EXPLOSION, HURT, JUMP, PATCH, TAP }

const SOUND_MAP := {
	SFX.PICK_UP: preload("res://assets/sounds/power_up.wav"),
	SFX.EXPLOSION: preload("res://assets/sounds/explosion.wav"),
	SFX.HURT: preload("res://assets/sounds/hurt.wav"),
	SFX.JUMP: preload("res://assets/sounds/jump.wav"),
	SFX.PATCH: preload("res://assets/sounds/power_up.wav"),
	SFX.TAP: preload("res://assets/sounds/tap.wav"),
}

func play_sfx(sfx_id: SFX):
	if not SOUND_MAP.has(sfx_id):
		push_warning("Unknown SFX ID: %s" % str(sfx_id))
		return

	var new_player = AudioStreamPlayer2D.new()
	new_player.stream = SOUND_MAP[sfx_id]
	new_player.pitch_scale = randf_range(0.95, 1.05)
	new_player.volume_db = volume_db  # optional: inherit volume
	add_child(new_player)  # Add to scene tree to play

	new_player.play()

	# Queue free after sound is done playing
	new_player.finished.connect(Callable(new_player, "queue_free"))
