extends Sprite2D

var d = 20
var radius = 150.0
var speed = 0.1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	d += delta
	position = Vector2(-sin(d * speed) * radius, cos(d * speed) * radius)
	
	
	
