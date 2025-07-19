extends AnimatableBody2D


@onready var animation_player: AnimationPlayer = $AnimationPlayer

var triggered : bool = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and not triggered:
		animation_player.play("rotate")
		
		triggered = true
