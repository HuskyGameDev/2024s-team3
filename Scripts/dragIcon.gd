extends TextureRect



func _get_drag_data(at_position):
	var inv_data = PlayerData.read_inv()
	#var equipment_slot = get_parent().get_name()
	var inv_slot = get_parent().get_name()
	if inv_data[inv_slot]["Item"] != null:
		var data = { }
		data["origin_node"] = self
		data["origin_item_id"] = inv_data[inv_slot]["Item"]
		data["origin_texture"] = texture
	
		var drag_texture = TextureRect.new( )
		drag_texture.expand = true
		drag_texture.texture = texture
		drag_texture.size = Vector2(100, 100)
		
		var control = Control.new()
		control.add_child(drag_texture)
		drag_texture.position = -0.5 * drag_texture.size
		set_drag_preview(control)
		return data

#basically doesnt matter rn. checks if we are able to place item in this slot
func _can_drop_data(at_position, data):
	var inv_data = PlayerData.read_inv()
	var target_inv_slot = get_parent().get_name()
	if inv_data[target_inv_slot]["Item"] == null:
		data["target_item_id"] = null
		data["target_texture"] = null
		return true
	else:
		data["target_item_id"] = inv_data[target_inv_slot]["Item"]
		data["target_texture"] = texture
		return true
		

func _drop_data(at_position, data):
	var inv_data = PlayerData.read_inv()
	var target_inv_slot = get_parent().get_name()
	var origin_slot = data["origin_node"].get_parent().get_name()
	
	inv_data[origin_slot]["Item"] = data["target_item_id"]
	data["origin_node"].texture = data["target_texture"]
	inv_data[target_inv_slot]["Item"] = data["origin_item_id"]
	texture = data["origin_texture"]
