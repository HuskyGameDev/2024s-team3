extends Node

@export var data: Resource

func _on_draggable_object_ready():
	$"DraggableObject".set_meta("potion", self)
