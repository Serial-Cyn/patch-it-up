extends Area2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var shoot_cooldown: Timer = $ShootCooldown


var in_gun_zone : bool = false
var shoot : bool = false
var is_gun_cooldowned : bool = true

func _process(delta: float) -> void:
	if shoot:
		animated_sprite_2d.play("shoot")
		
	elif in_gun_zone and is_gun_cooldowned:
		animated_sprite_2d.play("charge")
		
	else:
		animated_sprite_2d.pause()


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		in_gun_zone = true


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		in_gun_zone = false


func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite_2d.animation == "charge":
		shoot = true
	
	if animated_sprite_2d.animation == "shoot":
		shoot_cooldown.start()
		is_gun_cooldowned = false
		shoot = false


func _on_shoot_cooldown_timeout() -> void:
	is_gun_cooldowned = true
