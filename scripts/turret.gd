extends Area2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var shoot_cooldown: Timer = $ShootCooldown
@onready var marker_2d: Marker2D = $Marker2D
@onready var boss: CharacterBody2D = %Boss

var laser = preload("res://scenes/turret_projectile.tscn")

var in_gun_zone : bool = false
var shoot : bool = false
var is_gun_cooldowned : bool = true
var laser_shot : bool = false

func _process(delta: float) -> void:
	if shoot:
		animated_sprite_2d.play("shoot")
		
		if not laser_shot:
			var beam = laser.instantiate()
			beam.position = marker_2d.position
			add_child(beam)
			
			laser_shot = true
		
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
		if boss:
			boss.damage()
		is_gun_cooldowned = false
		shoot = false


func _on_shoot_cooldown_timeout() -> void:
	is_gun_cooldowned = true
	laser_shot = false
