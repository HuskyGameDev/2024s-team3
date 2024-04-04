extends Node

func _on_buy_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/Screens/NightShop/NightShop.tscn")


func _on_forage_button_pressed():
	var foragedItems = PlayerData.save.currentLocation.forage_items(3)
	for i in foragedItems:
		PlayerData.add_item_to_inventory(i, 1);
	PlayerData._on_end_of_day()
	get_tree().change_scene_to_file("res://Scenes/Screens/Main.tscn")


func _on_move_button_pressed():
	print("moving not implemented yet")
	get_tree().change_scene_to_file("res://Scenes/Screens/Main.tscn")
