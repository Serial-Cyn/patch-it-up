extends Node2D

# --- Node References ---
@onready var game_manager: Node = %GameManager
@onready var sprite: Sprite2D = $Sprite
@onready var fix_area: Area2D = $FixArea
@onready var stop_area: Area2D = $StopArea

# --- State Flags ---
var is_patched: bool = false
var player_in_range: bool = false

# --- Initialization ---
func _ready() -> void:
	stop_area.monitoring = false     # Disable stop zone until patched
	sprite.frame = 0                 # Show broken/glitched sprite


# --- Interaction Detection ---
func _on_fix_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_in_range = true

func _on_fix_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_in_range = false


# --- Input Handling ---
func _process(_delta: float) -> void:
	if player_in_range and Input.is_action_just_pressed("patch"):
		patch_stop_point()


# --- Patching Logic ---
func patch_stop_point():
	if is_patched:
		return

	is_patched = true
	sprite.frame = 4               # Show fixed/patched sprite
	fix_area.queue_free()          # Remove fix interaction
	stop_area.monitoring = true    # Activate stop zone


# --- Stop Zone Detection ---
func _on_stop_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.is_in_safe_zone = true

func _on_stop_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.is_in_safe_zone = false
