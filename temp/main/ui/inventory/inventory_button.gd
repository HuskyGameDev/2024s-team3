extends Button

var curItem
var curIcon
var curLabel
var index
signal OnButtonClick(Index, item)
var heldBody

# Called when the node enters the scene tree for the first time.
func _ready():
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
	emit_signal("OnButtonClick", index, curItem)

func _on_inv_area_body_entered(body):
	if body.get("object_type") == "Ingredient":
		heldBody = body

func _on_inv_area_body_exited(_body):
	heldBody = null

func _on_inv_area_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton && not event.pressed  && event.button_index == MOUSE_BUTTON_LEFT:
		if heldBody != null:
			var holding = heldBody.get("object_data")
			var slot = self.name
			var inv_data = PlayerData.read_inv()
			var slotAmount = inv_data[slot]["Quantity"]
			var item = ResourceLoader.load("res://Assets/Resources/Ingredients/" + holding.id + ".tres")
			if inv_data[slot]["Item"] == item.id && slotAmount != item.stackSize: #if this ingredient already exists in inventory
				if slotAmount + 1 <= item.stackSize: #if adding this quantity to the amount in the stack would be larger than stack size
					inv_data[slot]["Quantity"] = slotAmount + 1
					heldBody.queue_free()
					UpdateItem(item, slotAmount + 1, self.get_index())
			elif inv_data[slot]["Item"] == null: #if this slot is empty 
				inv_data[slot]["Item"] = item.id
				inv_data[slot]["Quantity"] = 1
				heldBody.queue_free()
				UpdateItem(item, 1, self.get_index())
			PlayerData.write_inv(inv_data)
