extends CharacterBody2D

@onready var game_manager: Node = %GameManager
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite
@onready var corruption_timer: Timer = $"../GameManager/CorruptionTimer"
@onready var main_camera: Camera2D = $MainCamera
@onready var sound_effects: AudioStreamPlayer2D = %SoundEffects
@onready var move_timer: Timer = $MoveTimer
@onready var warning_timer: Timer = $WarningTimer
@onready var invincibility_timer: Timer = $InvincibilityTimer
@onready var hit_blinker_timer: Timer = $HitBlinkerTimer
@onready var hurt_timer: Timer = $HurtTimer
@onready var walk: AudioStreamPlayer2D = $Walk

const SPEED : float = 100.0
const JUMP_VELOCITY : float = -300.0
const GRAVITY : float = 900.0
const MAX_BLINKS := 6  # 3 visible + 3 invisible toggles

# Movement
var gravity_direction : int
var reverse_control : int
var direction : int
var move_left : int
var move_right : int
var not_strafe : bool = true
var last_position_x : float
var move_counter : int = 0
var COYOTE_TIME : float = 0.15
var coyote_time_remaining : float = 0.0

# States
var is_airborne : bool
var is_moving : bool
var is_in_safe_zone : bool = false
var dead : bool = false
var stay_dead : bool = false
var was_moving_left : bool = false
var was_moving_right : bool = false
var warn_player : bool = false
var strafe_detected : bool = false
var is_hurt : bool = false
var is_invincible : bool = false

# VFX
var shake_timer : float = 0.0
var shake_intensity : float = 0.0
var blink_count := 0

func _ready() -> void:
	last_position_x = 0
	gravity_direction = 1
	reverse_control = 1

func _process(delta: float) -> void:
	if shake_timer > 0:
		shake_timer -= delta
		var offset = Vector2(
			randf_range(-1.0, 1.0),
			randf_range(-1.0, 1.0)
		) * shake_intensity
		main_camera.offset = offset
	else:
		main_camera.offset = Vector2.ZERO

func _physics_process(delta: float) -> void:
	if not dead:
		handle_movement(delta)
		
	apply_gravity(delta)
	handle_animation()
	handle_corruption_timer()
	move_and_slide()

func shake_screen(intensity : float, duration : float = 0.3) -> void:
	shake_intensity = intensity
	shake_timer = duration

func handle_movement(delta):
	move_left = Input.get_action_strength("move_left")
	move_right = Input.get_action_strength("move_right")
	
	direction = move_right - move_left
	velocity.x = reverse_control * direction * SPEED
	
	if is_on_floor():
		coyote_time_remaining = COYOTE_TIME
	else:
		coyote_time_remaining = max(coyote_time_remaining - delta, 0.0)
	
	if last_position_x != self.position.x:
		is_moving = true
	else:
		is_moving = false
	
	if Input.is_action_just_pressed("jump") and (is_on_floor() or coyote_time_remaining > 0.0):
		velocity.y = JUMP_VELOCITY
		coyote_time_remaining = 0.0  # Cancel coyote after using it
		
		
		sound_effects.play_sfx(sound_effects.SFX.JUMP)
	
	last_position_x = self.position.x

func apply_gravity(delta):
	is_airborne = not is_on_floor()
	if is_airborne:
		velocity.y += gravity_direction * GRAVITY * delta

func handle_animation():
	if not dead:
		if not is_hurt:
			if not is_airborne:
				if direction != 0:
					if animated_sprite.animation != "run":
						walk.pitch_scale = randf_range(0.95, 1.05)
						walk.play()
						animated_sprite.play("run")
					animated_sprite.flip_h = reverse_control * direction < 0
				else:
					walk.stop()
					if animated_sprite.animation != "idle":
						animated_sprite.play("idle")
			else:
				
				if animated_sprite.animation != "jump":
					animated_sprite.play("jump")
				if direction != 0:
					animated_sprite.flip_h = reverse_control * direction < 0
					
		else:
			animated_sprite.play("hit")
			
			if not hit_blinker_timer.is_stopped():
				hit_blinker_timer.stop()
			
			hit_blinker_timer.start()
			
	else:
		if not stay_dead:
			animated_sprite.play("death")
			
			stay_dead = true

func start_anti_strafe() -> void:
	not_strafe = false
	move_counter += 1
	
	if not strafe_detected and move_counter > 5:
		sound_effects.play_sfx(sound_effects.SFX.ANTI)
		
		strafe_detected = true
		
	move_timer.start()

func get_current_dir(moving_left: bool) -> String:
	if moving_left:
		return "left"
	else:
		return "right"

func was_opposite_dir(current_dir: String) -> bool:
	if current_dir == "left":
		return was_moving_right
	else:
		return was_moving_left

func handle_direction_change(current_dir: String, was_opposite: bool) -> void:
	if was_opposite:
		# Direction suddenly changed: trigger anti-strafe behavior
		start_anti_strafe()
		
		# Reset opposite direction flag
		if current_dir == "left":
			was_moving_right = false
		else:
			was_moving_left = false

func reset_movement_flags() -> void:
	# Resets direction flags when no key is pressed
	was_moving_left = false
	was_moving_right = false

func check_for_key_strokes() -> void:
	var moving_left := move_left > 0
	var moving_right := move_right > 0
	
	# Handle "both keys pressed" case
	if moving_left and moving_right:
		not_strafe = false
		
		return

	# If moving in only one direction
	if moving_left or moving_right:
		var current_dir = get_current_dir(moving_left)
		var was_opposite = was_opposite_dir(current_dir)
		handle_direction_change(current_dir, was_opposite)

		# Update direction flags
		if current_dir == "left":
			was_moving_left = true
		else:
			was_moving_right = true
			
	else:
		# No input detected
		is_moving = false
		
		if warn_player:
			var warn_idle : float = randi_range(1, 100)
			
			if warn_idle <= 2:
				if warn_idle <= 1:
					sound_effects.play_sfx(sound_effects.SFX.IDLE_1)
				else:
					sound_effects.play_sfx(sound_effects.SFX.IDLE_2)
				
				warn_player = false
		
		reset_movement_flags()

func handle_corruption_timer() -> void:
	check_for_key_strokes()
	
	# Only pause timer if player is moving or in a safe zone
	if not game_manager.level_complete:
		if (is_moving or is_in_safe_zone) and not_strafe:
			corruption_timer.paused = true
			game_manager.safe = true
		else:
			corruption_timer.paused = false
			game_manager.safe = false

func hurt():
	if not is_invincible:
		invincibility_timer.wait_time = 1.0
		
		hurt_timer.start()
		invincibility_timer.start()
		
		is_invincible = true
		is_hurt = true

func _on_move_timer_timeout() -> void:
	not_strafe = true
	strafe_detected = false
	
	move_counter = 0

func _on_warning_timer_timeout() -> void:
	warning_timer.wait_time = randi_range(30, 60)
	warn_player = true

func _on_invincibility_timer_timeout() -> void:
	is_invincible = false

func _on_hit_blinker_timer_timeout() -> void:
	if blink_count < MAX_BLINKS:
		if animated_sprite.modulate.a == 0.0:
			animated_sprite.modulate.a = 1.0
		else:
			animated_sprite.modulate.a = 0.0
			
		blink_count += 1
		
		hit_blinker_timer.start()
	else:
		# Reset visibility and blink counter
		animated_sprite.modulate.a = 1.0
		blink_count = 0

func _on_hurt_timer_timeout() -> void:
	is_hurt = false
