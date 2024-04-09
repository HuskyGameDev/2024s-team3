extends Sprite2D

var rotation_speed = 0.001

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_rotation += (rotation_speed + randf_range(.003, .006))
