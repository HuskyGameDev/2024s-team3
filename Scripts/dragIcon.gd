#Wade Canavan
#drags item texture with mouse and places item in selected inventory slot
extends TextureRect

#gets data about the item and slot it started in. Moves texture with mouse
func _get_drag_data(_at_position):
	var inv_data = PlayerData.read_inv()
	var inv_slot = get_parent().get_name()
	if inv_data[inv_slot]["Item"] != null:
		var data = { }
		data["origin_node"] = self
		data["origin_item_id"] = inv_data[inv_slot]["Item"]
		data["origin_texture"] = texture
		data["origin_quantity"] = inv_data[inv_slot]["Quantity"]
		find_parent("Drawer-inventory")._get_dragging(inv_slot)
		var drag_texture = TextureRect.new( )
		drag_texture.expand = true
		drag_texture.texture = texture
		drag_texture.size = Vector2(100, 100)
		
		var control = Control.new()
		control.add_child(drag_texture)
		drag_texture.position = -0.5 * drag_texture.size
		set_drag_preview(control)
		return data

#gets data about the slot we want to place the item in
func _can_drop_data(_at_position, data):
	var inv_data = PlayerData.read_inv()
	var target_inv_slot = get_parent().get_name()		
	data["target_slot"] = get_parent()
	if inv_data[target_inv_slot]["Item"] == null:
		data["target_item_id"] = null
		data["target_texture"] = null
		data["target_quantity"] = 0
		return true
	else:
		data["target_item_id"] = inv_data[target_inv_slot]["Item"]
		data["target_texture"] = texture
		data["target_quantity"] = inv_data[target_inv_slot]["Quantity"]
		return true

#if we can put the item in the slot, updates new slot, starting slot, and json
func _drop_data(_at_position, data):
	var inv_data = PlayerData.read_inv()
	var target_slot = get_parent().get_name()
	var origin_slot = data["origin_node"].get_parent().get_name()
	if data["origin_item_id"] == data["target_item_id"] && target_slot != origin_slot:  #if target slot is same item as starting slot, merge the slots
		var item_name = str(data["origin_item_id"])
		var path = "res://Assets/Resources/Ingredients/" + str(item_name) + ".tres"
		var item = ResourceLoader.load(path)
		if Input.is_physical_key_pressed(KEY_SHIFT) : # we are moving whole stack
			if data["target_quantity"] + data["origin_quantity"] > item.stackSize: #if adding this quantity to the amount in the stack would be larger than max stack size
				inv_data[target_slot]["Quantity"] = item.stackSize #fill the target slot
				inv_data[origin_slot]["Quantity"] = data["origin_quantity"] - (item.stackSize -  data["target_quantity"])#leave the remaining in the staring slot
				data["target_slot"].get_node("Icon/Quantity").set_text( str(item.stackSize))
				data["origin_node"].get_node("Quantity").set_text( str(data["origin_quantity"] - (item.stackSize -  data["target_quantity"])))
			else: #else just move all of the item to target slot and update the quantity
				inv_data[origin_slot]["Item"] = null
				data["origin_node"].texture = null
				inv_data[target_slot]["Quantity"] = data["origin_quantity"] + data["target_quantity"]
				inv_data[origin_slot]["Quantity"] = 0
				data["origin_node"].get_node("Quantity").set_text(" ")
				data["target_slot"].get_node("Icon/Quantity").set_text( str(data["origin_quantity"] + data["target_quantity"]))
		elif data["target_quantity"] + 1 <= item.stackSize: #move just one item
			inv_data[target_slot]["Quantity"] = data["target_quantity"] + 1
			inv_data[origin_slot]["Quantity"] = data["origin_quantity"] - 1
			if data["origin_quantity"] == 1:			
				inv_data[origin_slot]["Item"] = null
				data["origin_node"].texture = null
				data["origin_node"].get_node("Quantity").set_text(" ")
			else: 
				data["origin_node"].get_node("Quantity").set_text(str(data["origin_quantity"] - 1))
			data["target_slot"].get_node("Icon/Quantity").set_text(str(data["target_quantity"] + 1))
	elif inv_data[origin_slot]["Quantity"] == float(1) || Input.is_physical_key_pressed(KEY_SHIFT) : #stack only contains one or we are moving whole stack
		inv_data[origin_slot]["Item"] = data["target_item_id"]
		inv_data[target_slot]["Item"] = data["origin_item_id"]
		data["origin_node"].texture = data["target_texture"]
		texture = data["origin_texture"]
		inv_data[origin_slot]["Quantity"] = data["target_quantity"]
		inv_data[target_slot]["Quantity"] = data["origin_quantity"]
		if data["target_quantity"] == 0:
			data["origin_node"].get_node("Quantity").set_text("")
		else:
			data["origin_node"].get_node("Quantity").set_text( str(data["target_quantity"]))
		data["target_slot"].get_node("Icon/Quantity").set_text( str(data["origin_quantity"]))
	elif inv_data[target_slot]["Quantity"] == 0 : # move only one item in larger stack
		inv_data[target_slot]["Item"] = data["origin_item_id"]
		texture = data["origin_texture"]
		inv_data[origin_slot]["Quantity"] = data["origin_quantity"] - 1
		inv_data[target_slot]["Quantity"] = 1
		data["origin_node"].get_node("Quantity").set_text( str(data["origin_quantity"] - 1))
		data["target_slot"].get_node("Icon/Quantity").set_text( str(1))
	PlayerData.write_inv(inv_data)
