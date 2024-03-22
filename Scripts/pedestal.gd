extends Button

var curIcon
var dragging
var held
var item
signal make_ped_object(item:Resource) #emits to main scene to create ingredient object

# Called when the node enters the scene tree for the first time.
func _ready():
	curIcon = $Icon

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_inv_area_body_entered(body):
	if body.get("object_type") == "Ingredient":
			dragging = body

func _on_inv_area_body_exited(body):
	dragging = null

func _on_inv_area_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton && not event.pressed  && event.button_index == MOUSE_BUTTON_LEFT:

		if dragging != null && held == null:
			dragging.queue_free()
			held = dragging.get("object_data")
			item = ResourceLoader.load("res://Assets/Resources/Ingredients/" + held.id + ".tres")
			curIcon.texture = item.image

func _on_button_up():
	if held != null and item != null:
		make_ped_object.emit(item)
		held = null
		item = null
		curIcon.texture = null

