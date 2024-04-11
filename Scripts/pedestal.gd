extends Button

var curIcon
var dragging
var held
var item
var image
signal make_ped_object(item:Resource) #emits to main scene to create ingredient object
signal sendToBell(item:Resource)  

# Called when the node enters the scene tree for the first time.
func _ready():
	curIcon = $Icon
	

func _on_inv_area_body_entered(body):
	print("object_type is: ", body.get("object_type"))
	if body.get("object_type") == "Potion":
			dragging = body

func _on_inv_area_body_exited(_body):
	dragging = null
	

func _on_inv_area_input_event(_viewport, event, _shape_idx): 
	#print("event is: ", event.to_string())
	if event is InputEventMouseButton && not event.pressed  && event.button_index == MOUSE_BUTTON_LEFT:
		if dragging != null && held == null:
			dragging.queue_free()
			held = dragging.get("object_data")
			#print("check if item loaded correctly ", ResourceLoader.has_cached("res://Assets/Resources/Potions/" + held.id + ".tres"))
			item = ResourceLoader.load("res://Assets/Resources/Potions/" + held.id + ".tres")
			sendToBell.emit(item);
			curIcon.texture = item.image
	#print("item is of type: ", item.get("object_type"))


func _on_button_up():
	if held != null and item != null:
		make_ped_object.emit(item) 
		held = null
		item = null
		dragging = null
		curIcon.texture = null
		

func _on_customer_take_potion(id):
	curIcon.texture = null
	item = null
	held = null
