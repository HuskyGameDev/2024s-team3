extends Node

@export var data: Resource

func _on_draggable_object_ready():
	$"DraggableObject".set("object_type", "Ingredient")
	$"DraggableObject".set("object_data", data)
	$"DraggableObject".call("data_updated")
