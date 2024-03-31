extends Node


func _on_buy_button_pressed():
	print("buying ingredients not implemented yet")
	get_tree().change_scene_to_file("res://Scenes/Screens/Main.tscn")


func _on_forage_button_pressed():
	var foragedItems = PlayerData.save.currentLocation.forage_items(3)
	for i in foragedItems:
		Insert(i, 1);
	PlayerData._on_end_of_day()
	get_tree().change_scene_to_file("res://Scenes/Screens/Main.tscn")


func _on_move_button_pressed():
	print("moving not implemented yet")
	get_tree().change_scene_to_file("res://Scenes/Screens/Main.tscn")

func Insert(item : Resource, quantity : int):
	var index = 0;
	var inv_data = PlayerData.read_inv()	
	for i in  inv_data: #find next available slot to put item
		
		var slotAmount = inv_data[i]["Quantity"]
		if inv_data[i]["Item"] == item.id && slotAmount != item.stackSize: #if this ingredient already exists in inventory
			if slotAmount + quantity > item.stackSize: #if adding this quantity to the amount in the stack would be larger than stack size
				inv_data[i]["Quantity"] = item.stackSize #fill the slot
				PlayerData.write_inv(inv_data)
				Insert(item, slotAmount + quantity - item.stackSize) #add the rest to a different slot
				break
			else: #else just update the quantity
				inv_data[i]["Quantity"] = slotAmount + quantity					
				break
		elif inv_data[i]["Item"] == null: #if this slot is empty 
			if quantity > 0:
				if quantity <= item.stackSize: #if quantity is not greater than allowed stack size add item to this slot

					inv_data[i]["Item"] = item.id
					inv_data[i]["Quantity"] = quantity					
					break
				else: #else add max stack size to this slot and add the excess to another slot
					inv_data[i]["Item"] = item.id
					inv_data[i]["Quantity"] = item.stackSize
					PlayerData.write_inv(inv_data)
					Insert(item, quantity - item.stackSize)
					break
			else:
				return
		index = index + 1
	PlayerData.write_inv(inv_data)
