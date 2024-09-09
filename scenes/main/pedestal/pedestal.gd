extends Button #Wade Canavan

var potionScene: PackedScene = preload("res://common/items/potions/potion.tscn")

var curIcon: TextureRect #the icon desplayed of the item in the pedestal
var dragging: Node #if something is being dragged over the pedestal
var item: Potion #the resource in the pedestal
signal makePedestalObject(item: Potion) #emits to main scene to create ingredient object
signal sendToBell(item: Potion)  

# Called when the node enters the scene tree for the first time.
func _ready():
	curIcon = $Icon


func _on_inv_area_body_entered(body): #on object dragged into pedestal area
	dragging = body # we don't have to check the body type because it only checks layer 32 (the potion dragging layer)


#clears object being dragged out of pedestal
func _on_inv_area_body_exited(_body):
	dragging = null


func _unhandled_input(event):
	if Input.is_action_just_released("click"): #if we release left mouse button
		if dragging && !item: #if we are dragging something and pedestal is empty
			dragging.queue_free() #destory object we are dragging
			#place object in pedestal
			item = dragging.data
			sendToBell.emit(item); #sends signal to main to indicate type of object in pedestal
			curIcon.texture = item.image

#called when item is dragged out of pedestal. Empties variables and 
#sends signal to main to make that potion object in the scene
func _on_button_up():
	if item:
		makePedestalObject.emit(item) 
		item = null
		dragging = null
		curIcon.texture = null

#called when bell is rung and correct potion is on pedestal. Empties variables
func _on_customer_take_potion():
	curIcon.texture = null
	item = null
