extends Node

@export var data: Potion
var rigidbody: RigidBody2D

func _ready():
	$"DraggableObject".set("object_type", "Potion")
	$"DraggableObject".set("object_data", data)
	$"DraggableObject".call("data_updated")
	rigidbody = $"DraggableObject"

