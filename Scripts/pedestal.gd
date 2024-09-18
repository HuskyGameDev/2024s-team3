extends Button #Wade Canavan

var curIcon #the icon desplayed of the item in the pedestal
var dragging #if something is being dragged over the pedestal
var held #the object in the pedestal
var item #the resource in the pedestal
var potionOnPedestal:String #stores the resource sent on pedestal
signal correctOrder(id:Resource)
var PotionScene = preload("res://Scenes/Entities/Potion.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	curIcon = $Icon
	var main = get_parent()
	main.emptyPedestal.connect(_on_customer_take_potion)

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
			potionOnPedestal = item.id #store type of potion made
			curIcon.texture = item.image # set picture on pedestal to image of potion

#called when item is dragged out of pedestal. Empties pedestal and put item in main 
func _on_button_up():
	if held != null and item != null:
		# create new item in main 
		var newItem = PotionScene.instantiate() # create potion object
		newItem.setType(item)
		newItem.global_position = get_viewport().get_mouse_position() # place potion at mouse location
		get_parent().add_child(newItem) # set object to a child of main
		
		#empty pendestal
		held = null
		item = null
		dragging = null
		curIcon.texture = null

#called when bell is rung and correct potion is on pedestal. Empties pedestal
func _on_customer_take_potion():
	curIcon.texture = null
	item = null
	held = null

# when bell is rumg emit signal to main with the type of potion in the pedestal so it can check it with the cutomer order
func _on_ring_bell_pressed():
	if !potionOnPedestal: return
	correctOrder.emit(potionOnPedestal)
