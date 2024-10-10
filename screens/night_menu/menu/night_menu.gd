extends Node

func _ready():
	$"CenterContainer/VBoxContainer/HBoxContainer/SalesNumber".text = "$%d" % PlayerData.moneyToday
	$"CenterContainer/VBoxContainer/HBoxContainer/ReputationNumber".text = "%d Reputation" % PlayerData.repToday

func _on_buy_button_pressed():
	get_tree().change_scene_to_file("res://screens/night_menu/store/night_shop.tscn")


func _on_forage_button_pressed():
	var foragedItems = PlayerData.location.forage_items(3)
	for i in foragedItems:
		PlayerData.add_item_to_inventory(i, 1);
	get_tree().change_scene_to_file("res://screens/main/packed_main.tscn")


func _on_move_button_pressed():	
	get_tree().change_scene_to_file("res://screens/night_menu/map/night_map.tscn")
