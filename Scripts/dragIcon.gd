extends TextureRect



func _get_drag_data(at_position):
	var inv_data = PlayerData.read_inv()
	#var equipment_slot = get_parent().get_name()
	var inv_slot = get_parent().get_name()
	print(inv_data[inv_slot]["Item"])
	if inv_data[inv_slot]["Item"] != null:
		var data = { }
		data["origin_node"] = self
		data["origin_item_id"] = inv_data[inv_slot]["Item"]
		data["origin_texture"] = texture
		data["origin_quantity"] = inv_data[inv_slot]["Quantity"]
		
		var drag_texture = TextureRect.new( )
		drag_texture.expand = true
		drag_texture.texture = texture
		drag_texture.size = Vector2(100, 100)
		
		var control = Control.new()
		control.add_child(drag_texture)
		drag_texture.position = -0.5 * drag_texture.size
		set_drag_preview(control)
		return data

#basically doesnt matter rn. checks if we are able to place item in this slot. places data in array for us to move
func _can_drop_data(at_position, data):
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
		

func _drop_data(at_position, data):
	var inv_data = PlayerData.read_inv()
	var target_slot = get_parent().get_name()
	var origin_slot = data["origin_node"].get_parent().get_name()
	
	if inv_data[origin_slot]["Quantity"] == 1 || Input.is_physical_key_pressed(KEY_SHIFT) : #stack only contains one or we are moving whole stack
		inv_data[origin_slot]["Item"] = data["target_item_id"]
		data["origin_node"].texture = data["target_texture"]
		inv_data[target_slot]["Item"] = data["origin_item_id"]
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
