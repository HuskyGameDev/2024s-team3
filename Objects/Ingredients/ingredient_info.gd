extends Node

@export var id: int
@export var ingredientName: String
@export var image: Texture2D
@export_multiline var description: String

func _on_draggable_object_ready():
	$"DraggableObject".set_meta("ingredient", self)
