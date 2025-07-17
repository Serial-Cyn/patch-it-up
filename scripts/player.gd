extends CharacterBody2D

@onready var game_manager: Node = %GameManager
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite
@onready var corruption_timer: Timer = $"../GameManager/CorruptionTimer"
@onready var main_camera: Camera2D = $MainCamera
@onready var sound_effects: AudioStreamPlayer2D = %SoundEffects

const SPEED : float = 100.0
const JUMP_VELOCITY : float = -300.0
const GRAVITY : float = 900.0

# Movement
var gravity_direction : int
var reverse_control : int
var direction : int
var move_left : int
var move_right : int

# States
var is_airborne : bool
var is_moving : bool
var is_in_safe_zone : bool = false

# VFX
var shake_timer : float = 0.0
var shake_intensity : float = 0.0

func _ready() -> void:
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
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
		sound_effects.play_sfx(sound_effects.SFX.JUMP)

func apply_gravity(delta):
	is_airborne = not is_on_floor()
	if is_airborne:
		velocity.y += gravity_direction * GRAVITY * delta

func handle_animation():
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

func handle_corruption_timer():
	# Only pause the timer when either:
	# - The player is moving
	# - OR the player is in a patched stop zone
	is_moving = move_left > 0 or move_right > 0
	
	if is_moving or is_in_safe_zone:
		corruption_timer.paused = true
	else:
		corruption_timer.paused = false
