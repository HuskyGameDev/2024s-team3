extends RigidBody2D
var beingHeld = false
var draggingDistance = 0
var dir = 0
var dragging = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.is_pressed() && beingHeld:
			draggingDistance = position.distance_to(get_viewport().get_mouse_position())
			dir = (get_viewport().get_mouse_position() - position).normalized().x
			dragging = true
			print("click")
		else:
			print("unclicked")
			dragging = false
	elif event is InputEventMouseMotion:
		if dragging && beingHeld == false:
			position.x = (get_viewport().get_mouse_position()).x
			print("drag")

func _on_mouse_entered():
	beingHeld = true
	pass # replace with function body

func _on_mouse_exited():
	beingHeld = false
	pass # replace with function body

func _integrate_forces(_state):
	if beingHeld:
		var mousePos = get_global_mouse_position()
		var distance = global_position.distance_to(mousePos)
		var direction = global_position.direction_to(mousePos)
		rotation = 0 
		set_linear_velocity(direction * distance * 40)
