extends Node

@export var data: Potion
@onready var draggable: RigidBody2D = $DraggableObject
@onready var childRigid = $RigidBody2D
var rigidbody: RigidBody2D


func _ready():
	$"DraggableObject".set("object_type", "Potion")
	#self.rigidbody = $"DraggableObject"
	#draggable.set_collision_layer_value(2,true)
	#draggable.set_collision_mask_value(2, true)
	

func setType(type:Potion):
	self.data = type
	$"DraggableObject".set("object_type", "Potion")
	$"DraggableObject".set("object_data", data)
	$"DraggableObject".call("data_updated")
