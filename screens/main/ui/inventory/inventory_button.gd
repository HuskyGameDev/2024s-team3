extends Button

var tooltip = preload("res://ui/tooltip/tooltip.tscn")

var curItem
var curIcon
var curLabel
var index
signal OnButtonClick(Index, item)
signal SlotPressed(item:Resource) #emits to main scene to create ingredient object
signal makeObject(index)
var heldBody
var slot
var inv_data
var instance
var timer: Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	timer = Timer.new()
	add_child(timer)
	instance = tooltip.instantiate() # instantiate tooltip
	add_child(instance)
	instance.visible = false
	
	inv_data = PlayerData.read_inv()
	slot = self.name
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
		makeObject.emit(self.name)
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
			inv_data = PlayerData.read_inv()
			var slotAmount = inv_data[slot]["Quantity"]
			var item = ResourceLoader.load(ResourcePaths.get_ingredient_path(holding.id))
			if inv_data[slot]["Item"] == item.id && int(slotAmount) != item.stack_size: #if this ingredient already exists in inventory
				if int(slotAmount) + 1 <= item.stack_size: #if adding this quantity to the amount in the stack would be larger than stack size
					inv_data[slot]["Quantity"] = int(slotAmount) + 1
					heldBody.queue_free()
					UpdateItem(item, int(slotAmount) + 1, self.get_index())
					instance.set_text(item.name, item.description)
			elif inv_data[slot]["Item"] == null: #if this slot is empty 
				inv_data[slot]["Item"] = item.id
				inv_data[slot]["Quantity"] = 1
				heldBody.queue_free()
				UpdateItem(item, 1, self.get_index())
				if instance != null:
					instance.set_text(item.name, item.description)
			PlayerData.write_inv(inv_data)


func _on_mouse_entered():
	if heldBody == null:
		timer.start(1)
		await timer.timeout
		var ingredient = inv_data[self.name]["Item"]
		if ingredient != null:
			var item = ResourceLoader.load(ResourcePaths.get_ingredient_path(ingredient))
			instance.position = self.global_position + Vector2(-500,100)
			instance.set_text(item.name, item.description)
			instance.add_text("\nEffects:")
			for str in item.effects.get_strongest_as_strings():
				instance.add_text("\n" + str)
			instance.visible = true

func _on_mouse_exited():
	if instance != null:
		instance.visible = false
	timer.stop()
