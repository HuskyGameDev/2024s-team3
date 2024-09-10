extends Node

func _ready():
	$"CenterContainer/VBoxContainer/HBoxContainer/SalesNumber".text = "$%d" % PlayerData.moneyToday
	$"CenterContainer/VBoxContainer/HBoxContainer/ReputationNumber".text = "%d Reputation" % PlayerData.repToday

func _on_buy_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/Screens/NightShop/NightShop.tscn")


func _on_forage_button_pressed():
	#var foragedItems = PlayerData.save.currentLocation.forage_items(3)
	#for i in foragedItems:
		#PlayerData.add_item_to_inventory(i, 1);
	#PlayerData.save_game()
	get_tree().change_scene_to_file("res://Scenes/Screens/Main.tscn")


func _on_move_button_pressed():	
	get_tree().change_scene_to_file("res://Scenes/Screens/NightMap.tscn")
