extends Button #Wade Canavan

var curIcon #the icon desplayed of the item in the pedestal
var dragging #if something is being dragged over the pedestal
var held #the object in the pedestal
var item #the resource in the pedestal
signal make_ped_object(item:Resource) #emits to main scene to create ingredient object
signal sendToBell(item:Resource)  

# Called when the node enters the scene tree for the first time.
func _ready():
	curIcon = $Icon
	var main = get_parent()
	main.CorrectGoToCustSpawner.connect(_on_customer_take_potion)

func _on_inv_area_body_entered(body): #on object dragged into pedestal area
	if body.get("object_type") == "Potion":
			dragging = body

#clears object being dragged out of pedestal
func _on_inv_area_body_exited(_body):
	dragging = null

func _on_inv_area_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton && not event.pressed  && event.button_index == MOUSE_BUTTON_LEFT: #if we release left mouse button
		if dragging != null && held == null: #if we are dragging something and pedestal is empty
			dragging.queue_free() #destory object we are dragging
			#place object in pedestal
			held = dragging.get("object_data") 
			item = ResourceLoader.load("res://Assets/Resources/Potions/" + held.id + ".tres")
			sendToBell.emit(item); #sends signal to main to indicate type of object in pedestal
			curIcon.texture = item.image 

#called when item is dragged out of pedestal. Empties variables and 
func _on_button_up():
	if held != null and item != null:
		make_ped_object.emit(item) #sends signal to main to make that potion object iin the scene
		held = null
		item = null
		dragging = null
		curIcon.texture = null

#called when bell is rung and correct potion is on pedestal. Empties variables
func _on_customer_take_potion():
	curIcon.texture = null
	item = null
	held = null
