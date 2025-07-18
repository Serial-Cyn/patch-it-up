extends CharacterBody2D

@onready var game_manager: Node = %GameManager
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite
@onready var corruption_timer: Timer = $"../GameManager/CorruptionTimer"
@onready var main_camera: Camera2D = $MainCamera
@onready var sound_effects: AudioStreamPlayer2D = %SoundEffects
@onready var move_timer: Timer = $MoveTimer

const SPEED : float = 100.0
const JUMP_VELOCITY : float = -300.0
const GRAVITY : float = 900.0

# Movement
var gravity_direction : int
var reverse_control : int
var direction : int
var move_left : int
var move_right : int
var not_strafe : bool = true
var last_position_x : float

# States
var is_airborne : bool
var is_moving : bool
var is_in_safe_zone : bool = false
var dead : bool = false
var stay_dead : bool = false
var was_moving_left : bool = false
var was_moving_right : bool = false

# VFX
var shake_timer : float = 0.0
var shake_intensity : float = 0.0

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
		handle_movement()
		
	apply_gravity(delta)
	handle_animation()
	handle_corruption_timer()
	move_and_slide()

func shake_screen(intensity : float, duration : float = 0.3) -> void:
	shake_intensity = intensity
	shake_timer = duration

func handle_movement():
	move_left = Input.get_action_strength("move_left")
	move_right = Input.get_action_strength("move_right")
	
	direction = move_right - move_left
	velocity.x = reverse_control * direction * SPEED
	
	if last_position_x != self.position.x:
		is_moving = true
	else:
		is_moving = false
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
		sound_effects.play_sfx(sound_effects.SFX.JUMP)
	
	last_position_x = self.position.x

func apply_gravity(delta):
	is_airborne = not is_on_floor()
	if is_airborne:
		velocity.y += gravity_direction * GRAVITY * delta

func handle_animation():
	if not dead:
		if not is_airborne:
			if direction != 0:
				if animated_sprite.animation != "run":
					animated_sprite.play("run")
				animated_sprite.flip_h = reverse_control * direction < 0
			else:
				if animated_sprite.animation != "idle":
					animated_sprite.play("idle")
		else:
			if animated_sprite.animation != "jump":
				animated_sprite.play("jump")
			if direction != 0:
				animated_sprite.flip_h = reverse_control * direction < 0
	else:
		if not stay_dead:
			animated_sprite.play("death")
			
			stay_dead = true

func start_anti_strafe() -> void:
	not_strafe = false

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
		reset_movement_flags()

func handle_corruption_timer() -> void:
	check_for_key_strokes()
	
	# Only pause timer if player is moving or in a safe zone
	if (is_moving or is_in_safe_zone) and not_strafe:
		corruption_timer.paused = true
	else:
		corruption_timer.paused = false

func _on_move_timer_timeout() -> void:
	not_strafe = true
