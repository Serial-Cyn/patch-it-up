extends CharacterBody2D


@onready var player: CharacterBody2D = %Player
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var game_manager: Node = %GameManager
@onready var sound_effects: AudioStreamPlayer2D = %SoundEffects
@onready var death_platform_2: Node2D = $"../Traps/Chamber3/DeathPlatform2"
@onready var walk: AudioStreamPlayer2D = $Walk
@onready var label_2: Label = $"../UI/Label2"
@onready var hit_timer: Timer = $hitTimer


const SPEED = 5.0

var life : int = 3
var dead : bool = false
var player_pos : Vector2

var triggered : bool = false
var hit : bool = false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	if triggered:
		if life > 0:
			follow_player(delta)
		else:
			velocity.x = 0
			if not dead:
				animated_sprite_2d.play("death")
				
				dead = true
	
	move_and_slide()

func follow_player(delta):
	player_pos = player.position
	
	if not hit:
		animated_sprite_2d.play("walk")
	else:
		animated_sprite_2d.play("hit")
		
	if not walk.playing:
		walk.play()
	
	if player_pos.x > self.global_position.x:
		velocity.x += SPEED * delta
		animated_sprite_2d.flip_h = true
		
	elif player_pos.x < self.global_position.x:
		velocity.x -= SPEED * delta
		animated_sprite_2d.flip_h = false


func damage():
	life -= 1
	sound_effects.play_sfx(sound_effects.SFX.EXPLOSION)
	player.shake_screen(5.0)
	hit_timer.start()
	hit = true

func _on_hurt_box_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		game_manager.damage_player(20)


func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite_2d.animation == "death":
		label_2.text = "TASKS:\nLOCATE PATCHES"
		sound_effects.play_sfx(sound_effects.SFX.EXPLOSION)
		player.shake_screen(10.0)
		death_platform_2.queue_free()
		queue_free()


func _on_hit_timer_timeout() -> void:
	hit = false
