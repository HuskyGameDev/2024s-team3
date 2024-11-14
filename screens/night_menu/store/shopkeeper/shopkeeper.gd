extends Sprite2D

@onready var AnimPlayer = $AnimationPlayer

func _on_animation_finished(_anim_name):
	await get_tree().create_timer(randf_range(3, 10)).timeout
	AnimPlayer.queue("blink")
