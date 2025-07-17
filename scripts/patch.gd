extends CharacterBody2D

@onready var next_level_timer: Timer = $NextLevelTimer
@onready var player: CharacterBody2D = %Player

const FILE_BEGIN = "res://levels/level"
const FILE_END = ".tscn"

var current_scene_file
var current_level

func _ready() -> void:
	current_scene_file = get_tree().current_scene.scene_file_path
	current_level = current_scene_file.to_int()
	
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		match current_level:
			1:
				player.gravity_direction = 1
				player.reverse_control = 1
				
			2:
				pass
		# next_level_timer.start()


func next_level() -> void:
	var next_level_number = current_level + 1
		
	var next_level_path = FILE_BEGIN + str(next_level_number) + FILE_END
	get_tree().change_scene_to_file(next_level_path)


func _on_next_level_timer_timeout() -> void:
	next_level()
