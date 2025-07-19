extends CharacterBody2D


@onready var player: CharacterBody2D = %Player
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var game_manager: Node = %GameManager


const SPEED = 1.0

var player_pos : Vector2

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	follow_player(delta)
	move_and_slide()

func follow_player(delta):
	player_pos = player.position
	
	animated_sprite_2d.play("walk")
	
	if player_pos.x > self.global_position.x:
		velocity.x += SPEED * delta
		animated_sprite_2d.flip_h = true
		
	elif player_pos.x < self.global_position.x:
		velocity.x -= SPEED * delta
		animated_sprite_2d.flip_h = false


func _on_hurt_box_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		game_manager.damage_player(20)
