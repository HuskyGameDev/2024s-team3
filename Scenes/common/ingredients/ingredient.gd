extends Node

@export var data: Ingredient
@onready var draggable = $DraggableObject

func _ready():
	$"DraggableObject".set("object_type", "Ingredient")
	$"DraggableObject".set("object_data", data)
	$"DraggableObject".call("data_updated")
	
	draggable.set_collision_layer_value(1, true)
	draggable.set_collision_mask_value(1, true)
