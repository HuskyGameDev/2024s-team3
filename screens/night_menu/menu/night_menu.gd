extends Node

func _ready():
	$CanvasLayer/CenterContainer/VBoxContainer/HBoxContainer/SalesNumber.text = "$%d" % PlayerData.moneyToday
	$"CanvasLayer/CenterContainer/VBoxContainer/HBoxContainer/ReputationNumber".text = "%d Reputation" % PlayerData.repToday

func _on_buy_button_pressed():
	get_tree().change_scene_to_file("res://screens/night_menu/store/night_shop.tscn")


func _on_forage_button_pressed():
	get_tree().change_scene_to_file("res://screens/night_menu/forage/forage.tscn")


func _on_move_button_pressed():	
	get_tree().change_scene_to_file("res://screens/night_menu/map/night_map.tscn")
