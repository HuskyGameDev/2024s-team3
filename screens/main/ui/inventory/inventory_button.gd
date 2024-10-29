extends Button

var curItem
var curIcon
var curLabel
var index
signal OnButtonClick(Index, item)
signal SlotPressed(item:Resource) #emits to main scene to create ingredient object
var heldBody
var inventory
# Called when the node enters the scene tree for the first time.
func _ready():
	inventory = get_parent().get_parent().get_parent().get_parent().get_parent().get_parent()
	curIcon = $Icon
	curLabel = $Icon/Quantity

func UpdateItem(item:Resource, quantity: int, newIndex :int):
	self.index = newIndex
	curItem = item
	if curItem == null:
		curIcon.texture= null
		curLabel.text = ""
	else:
		curIcon.texture = item.image
		curLabel.text = str(quantity)

func _on_button_down():
	if Input.is_key_pressed(KEY_SHIFT):
		inventory.make_inventory_object(self.name)
	emit_signal("OnButtonClick", index, curItem)

func _on_inv_area_body_entered(body):
	if not body is DraggableObject: return	
	heldBody = body

func _on_inv_area_body_exited(_body):
	heldBody = null

func _on_inv_area_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton && not event.pressed  && event.button_index == MOUSE_BUTTON_LEFT:
		if heldBody != null and heldBody.data is Ingredient:
			var holding = heldBody.data			
			var slot = self.name
			var inv_data = PlayerData.read_inv()
			var slotAmount = inv_data[slot]["Quantity"]
			var item = ResourceLoader.load(ResourcePaths.get_ingredient_path(holding.id))
			if inv_data[slot]["Item"] == item.id && int(slotAmount) != item.stack_size: #if this ingredient already exists in inventory
				if int(slotAmount) + 1 <= item.stack_size: #if adding this quantity to the amount in the stack would be larger than stack size
					inv_data[slot]["Quantity"] = int(slotAmount) + 1
					heldBody.queue_free()
					UpdateItem(item, int(slotAmount) + 1, self.get_index())
			elif inv_data[slot]["Item"] == null: #if this slot is empty 
				inv_data[slot]["Item"] = item.id
				inv_data[slot]["Quantity"] = 1
				heldBody.queue_free()
				UpdateItem(item, 1, self.get_index())
			PlayerData.write_inv(inv_data)
