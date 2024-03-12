extends Node


func _on_buy_button_pressed():
	print("buying ingredients not implemented yet")
	get_tree().change_scene_to_file("res://Scenes/Screens/Main.tscn")


func _on_forage_button_pressed():
	var foragedItems = PlayerData.save.currentLocation.forage_items(3)
	print("Foraged items:")
	for i in foragedItems:
		print("  -" + i.ingredient_name)
	get_tree().change_scene_to_file("res://Scenes/Screens/Main.tscn")


func _on_move_button_pressed():
	print("moving not implemented yet")
	get_tree().change_scene_to_file("res://Scenes/Screens/Main.tscn")
