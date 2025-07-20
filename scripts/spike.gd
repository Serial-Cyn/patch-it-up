extends AnimatableBody2D

@onready var game_manager: Node = %GameManager


var DAMAGE : float = 5.0

func _on_hurt_box_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		game_manager.damage_player(DAMAGE)
