extends RigidBody2D

@export var stats: Resource


# Called when the node enters the scene tree for the first time.
func _ready():
	if stats:
		stats.health = true
		print(stats.health)

