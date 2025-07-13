extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite
@onready var corruption_timer: Timer = $CorruptionTimer

const SPEED : float = 100.0
const JUMP_VELOCITY : float = -300.0
const GRAVITY : float = 900.0

# Movement
var direction : int
var move_left : int
var move_right : int
# States
var is_airborne : bool
var is_moving : bool

func _physics_process(delta: float) -> void:
	handle_movement()
	apply_gravity(delta)
	handle_animation()
	handle_corruption_timer()
	move_and_slide()


func handle_movement():
	move_left = Input.get_action_strength("move_left")
	move_right = Input.get_action_strength("move_right")
	
	direction = move_right - move_left
	velocity.x = direction * SPEED
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

func apply_gravity(delta):
	is_airborne = not is_on_floor()
	if is_airborne:
		velocity.y += GRAVITY * delta

func handle_animation():
	if not is_airborne:
		if direction != 0:
			if animated_sprite.animation != "run":
				animated_sprite.play("run")
			animated_sprite.flip_h = direction < 0
		else:
			if animated_sprite.animation != "idle":
				animated_sprite.play("idle")
	else:
		if animated_sprite.animation != "jump":
			animated_sprite.play("jump")
		if direction != 0:
			animated_sprite.flip_h = direction < 0

func handle_corruption_timer():
	is_moving = move_left > 0 or move_right > 0
	corruption_timer.paused = is_moving
	
	print(corruption_timer.time_left)
