extends CharacterBody2D

@onready var next_level_timer: Timer = $NextLevelTimer
@onready var player: CharacterBody2D = %Player
@onready var sound_effects: AudioStreamPlayer2D = %SoundEffects
@onready var game_manager: Node = %GameManager
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite
@onready var area_2d: Area2D = $Area2D
@onready var label: Label = $"../UI/Label"
@onready var label_2: Label = $"../UI/Label2"


const FILE_BEGIN = "res://levels/level_"
const FILE_END = ".tscn"
const SPEED : float = 100.0

var current_scene_file
var current_level

var float_amplitude : float = 3.0
var float_speed : float = 1.0
var float_time : float = 0.0
var original_y : float = 0.0

var taken : bool = false
var can_run : bool = false
var trigger : bool = false

func _ready() -> void:
	current_scene_file = get_tree().current_scene.scene_file_path
	current_level = current_scene_file.to_int()
	
	original_y = position.y


func _process(delta: float) -> void:
	float_time += delta  # Keep counting time
	position.y = original_y + sin(float_time * float_speed * TAU) * float_amplitude
	
func _physics_process(delta: float) -> void:
	if can_run:
		position.x += SPEED * delta
		
	
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and not taken:
		match current_level:
			1:
				player.gravity_direction = 1
				label.text = "sys/ai >>> CONTROLS REVERSED"
				sound_effects.play_sfx(sound_effects.SFX.G_FIX)
				
			2:
				player.reverse_control = 1
				label.text = ""
				label_2.visible = false
				sound_effects.play_sfx(sound_effects.SFX.C_FIX)
				
				next_level_timer.wait_time = 7.0
		
		taken = true
		game_manager.stop_timer()
		sound_effects.play_sfx(sound_effects.SFX.PATCH)
		next_level_timer.start()
		animated_sprite.visible = false


func next_level() -> void:
	var next_level_number = current_level + 1

	var next_level_path = FILE_BEGIN + str(next_level_number) + FILE_END
	get_tree().change_scene_to_file(next_level_path)


func _on_next_level_timer_timeout() -> void:
	next_level()


func _on_run_trigger_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and not trigger:
		can_run = true
		trigger = true
		$StopTimer.start()

func _on_stop_timer_timeout() -> void:
	can_run = false
