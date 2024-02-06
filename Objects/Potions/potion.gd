extends Node

@export var data: Resource
var rigidbody: RigidBody2D

func _on_draggable_object_ready():
	$"DraggableObject".set("object_type", "Potion")
	$"DraggableObject".set("object_data", data)
	$"DraggableObject".call("data_updated")
	rigidbody = $"DraggableObject"

