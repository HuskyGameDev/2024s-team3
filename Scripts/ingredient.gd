extends Node

@export var data: Ingredient

func _ready():
	$"DraggableObject".set("object_type", "Ingredient")
	$"DraggableObject".set("object_data", data)
	$"DraggableObject".call("data_updated")
