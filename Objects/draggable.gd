extends RigidBody2D

############ Drag and Drop Functions ############
var beingHeld = false


func _unhandled_input(_event):
	if not Input.is_action_pressed("click") and beingHeld:
		beingHeld = false
		set_deferred("gravity_scale", 1)
		set_collision_layer_value(1, true)
		set_collision_mask_value(1, true)
		set_collision_mask_value(32, false)


func _on_input_event(_viewport, _event, _shape_idx):
	if Input.is_action_just_pressed("click"):
		beingHeld = true
		set_deferred("gravity_scale", 0)
		set_collision_layer_value(1, false)
		set_collision_mask_value(1, false)
		set_collision_mask_value(32, true)
		var tween = create_tween()
		tween.tween_property(self, "rotation", 0, 0.1)
	
	
func _integrate_forces(_state):
	if beingHeld:
		var mousePos = get_global_mouse_position()
		var distance = global_position.distance_to(mousePos)
		var direction = global_position.direction_to(mousePos)
		rotation = 0 
		set_linear_velocity(direction * distance * 15)


############### Object Functions ################
@export_enum("Potion", "Ingredient") var object_type: String
@export var object_data:Resource

func data_updated():
	if object_data and object_data.image != null:
		$"DraggableSprite".texture = object_data.image

