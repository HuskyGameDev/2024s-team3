extends Node2D

var held_object = false
@export var min_clamp:= Vector2.ZERO
@export var max_clamp:= Vector2(10,10)

func _ready():
	for node in get_tree().get_nodes_in_group("pickable"):
		node.clicked.connect(_on_pickable_clicked)
		
func _on_pickable_clicked(object):
	if !held_object:
		object.pickup()
		held_object = object
		
func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if held_object and !event.pressed:
			held_object.drop((Input.get_last_mouse_velocity()/2))
			held_object = null



##func _on_pickable_clicked(object):
##	if !held_object:
##		held_object = object
##		held_object.pickup()
##
##

##func _unhandled_input(event):
##	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
##		if held_object and !event.pressed:
##			held_object.drop(Input.get_last_mouse_velocity())
##			held_object = null


