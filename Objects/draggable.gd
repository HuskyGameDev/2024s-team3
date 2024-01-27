extends RigidBody2D

var beingHeld = false

func _on_input_event(_viewport, _event, _shape_idx):
	if Input.is_action_just_pressed("click"):
		beingHeld = true
		freeze = true
	elif Input.is_action_just_released("click"):
		beingHeld = false
		freeze = false
		self.apply_central_impulse((Input.get_last_mouse_velocity()/2))


func _physics_process(_delta):
	if beingHeld:
		global_transform.origin = get_global_mouse_position()


##set_collision_mask_value(1,false)
