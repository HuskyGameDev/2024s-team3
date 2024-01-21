extends RigidBody2D

@export var min_impulse_catch : Vector2 = Vector2(-10,-10)
@export var max_impulse_catch : Vector2 = Vector2 (10,10)
signal clicked

var held = false

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			print("clicked")
			clicked.emit(self)


func _physics_process(delta):
	if held:
		global_transform.origin = get_global_mouse_position()


func pickup():
	if held:
		return
	freeze = true
	held = true


func drop(impulse):
	if held:
		freeze = false
		print(impulse)
		apply_central_impulse(impulse)
		held = false



##set_collision_mask_value(1,false)


