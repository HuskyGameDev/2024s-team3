extends RigidBody2D

############ Drag and Drop Functions ############
var beingHeld = false

func _on_input_event(_viewport, _event, _shape_idx):
	if Input.is_action_just_pressed("click"):
		beingHeld = true
		set_deferred("freeze", true)
		set_collision_layer(32)
		var tween = create_tween()
		tween.tween_property(self, "rotation", 0, 0.1)
	elif Input.is_action_just_released("click"):
		beingHeld = false
		set_deferred("freeze", false)
		set_collision_layer(1)
		self.apply_central_impulse((Input.get_last_mouse_velocity()/2))


func _physics_process(_delta):
	if beingHeld:
		#global_transform.origin += get_local_mouse_position()
		global_transform.origin = get_global_mouse_position()
		

############### Object Functions ################
@export_enum("Potion", "Ingredient") var object_type: String
@export var object_data:Resource

func data_updated():
	if object_data and object_data.image != null:
		$"DraggableSprite".texture = object_data.image

